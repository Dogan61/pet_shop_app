const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');
const { sendSuccess, sendValidationError, sendNotFound, sendForbidden } = require('../utils/responseHelper');

// @desc    Get user favorites
// @route   GET /api/favorites
// @access  Private
exports.getFavorites = async (req, res, next) => {
  try {
    const db = getFirestore();
    const snapshot = await db.collection('favorites').where('userId', '==', req.user.uid).get();

    const favoritesWithPets = await Promise.all(
      snapshot.docs.map(async (doc) => {
        const favoriteData = doc.data();
        const petDoc = await db.collection('pets').doc(favoriteData.petId).get();

        if (!petDoc.exists) {
          return {
            id: doc.id,
            ...convertTimestamps(favoriteData),
            pet: null,
          };
        }

        return {
          id: doc.id,
          ...convertTimestamps(favoriteData),
          pet: {
            id: petDoc.id,
            ...convertTimestamps(petDoc.data()),
          },
        };
      })
    );

    sendSuccess(res, { favorites: favoritesWithPets, count: favoritesWithPets.length });
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
      return sendValidationError(res, 'Please provide pet ID');
    }

    const petDoc = await db.collection('pets').doc(petId).get();
    if (!petDoc.exists) {
      return sendNotFound(res, 'Pet not found');
    }

    const existingSnapshot = await db
      .collection('favorites')
      .where('userId', '==', req.user.uid)
      .where('petId', '==', petId)
      .get();

    if (!existingSnapshot.empty) {
      return sendValidationError(res, 'Pet already in favorites');
    }

    const favoriteData = {
      userId: req.user.uid,
      petId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const docRef = await db.collection('favorites').add(favoriteData);
    const newFavorite = await docRef.get();
    const favoriteResponseData = newFavorite.data();

    const petDetails = await db.collection('pets').doc(petId).get();
    const petResponseData = petDetails.exists ? petDetails.data() : null;

    sendSuccess(
      res,
      {
        id: newFavorite.id,
        ...convertTimestamps(favoriteResponseData),
        pet: petResponseData
          ? {
              id: petDetails.id,
              ...convertTimestamps(petResponseData),
            }
          : null,
      },
      'Favorite added successfully',
      201
    );
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
      return sendNotFound(res, 'Favorite not found');
    }

    if (favoriteDoc.data().userId !== req.user.uid) {
      return sendForbidden(res, 'Not authorized');
    }

    await favoriteRef.delete();

    sendSuccess(res, null, 'Favorite removed successfully');
  } catch (error) {
    next(error);
  }
};
