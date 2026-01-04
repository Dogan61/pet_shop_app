const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');

// @desc    Get user favorites
// @route   GET /api/favorites
// @access  Private
exports.getFavorites = async (req, res, next) => {
  try {
    const db = getFirestore();
    const snapshot = await db
      .collection('favorites')
      .where('userId', '==', req.user.uid)
      .get();
    
    // Get pet details for each favorite
    const favoritesWithPets = await Promise.all(
      snapshot.docs.map(async (doc) => {
        const favoriteData = doc.data();
        const petDoc = await db.collection('pets').doc(favoriteData.petId).get();
        
        if (!petDoc.exists) {
          // Pet not found, return favorite without pet data
          return {
            id: doc.id,
            ...convertTimestamps(favoriteData),
            pet: null,
          };
        }
        
        const petData = petDoc.data();
        return {
          id: doc.id,
          ...convertTimestamps(favoriteData),
          pet: {
            id: petDoc.id,
            ...convertTimestamps(petData),
          },
        };
      })
    );
    
    res.json({
      success: true,
      data: favoritesWithPets,
      count: favoritesWithPets.length,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Add favorite
// @route   POST /api/favorites
// @access  Private
exports.addFavorite = async (req, res, next) => {
  try {
    const db = getFirestore();
    const { petId } = req.body;
    
    if (!petId) {
      return res.status(400).json({
        success: false,
        message: 'Please provide pet ID',
      });
    }
    
    // Check if pet exists
    const petDoc = await db.collection('pets').doc(petId).get();
    if (!petDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found',
      });
    }
    
    // Check if already favorited
    const existingSnapshot = await db
      .collection('favorites')
      .where('userId', '==', req.user.uid)
      .where('petId', '==', petId)
      .get();
    
    if (!existingSnapshot.empty) {
      return res.status(400).json({
        success: false,
        message: 'Pet already in favorites',
      });
    }
    
    // Add favorite
    const favoriteData = {
      userId: req.user.uid,
      petId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    const docRef = await db.collection('favorites').add(favoriteData);
    const newFavorite = await docRef.get();
    const favoriteResponseData = newFavorite.data();
    
    // Fetch pet details to include in the response
    const petDetails = await db.collection('pets').doc(petId).get();
    const petResponseData = petDetails.exists ? petDetails.data() : null;
    
    res.status(201).json({
      success: true,
      data: {
        id: newFavorite.id,
        ...convertTimestamps(favoriteResponseData),
        pet: petResponseData ? {
          id: petDetails.id,
          ...convertTimestamps(petResponseData),
        } : null,
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Remove favorite
// @route   DELETE /api/favorites/:id
// @access  Private
exports.removeFavorite = async (req, res, next) => {
  try {
    const db = getFirestore();
    const favoriteRef = db.collection('favorites').doc(req.params.id);
    
    const favoriteDoc = await favoriteRef.get();
    if (!favoriteDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Favorite not found',
      });
    }
    
    // Check if user owns this favorite
    if (favoriteDoc.data().userId !== req.user.uid) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized',
      });
    }
    
    await favoriteRef.delete();
    
    res.json({
      success: true,
      message: 'Favorite removed successfully',
    });
  } catch (error) {
    next(error);
  }
};


