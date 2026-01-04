const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');

// @desc    Get all pets
// @route   GET /api/pets
// @access  Public
exports.getAllPets = async (req, res, next) => {
  try {
    const db = getFirestore();
    const { category, page = 1, limit = 10 } = req.query;
    
    let query = db.collection('pets');
    
    // Filter by category if provided
    if (category && category !== 'all') {
      query = query.where('category', '==', category);
    }
    
    // Get total count for pagination
    const countSnapshot = await query.get();
    const total = countSnapshot.size;
    
    // Apply pagination
    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const snapshot = await query
      .orderBy('createdAt', 'desc')
      .limit(parseInt(limit))
      .offset(startIndex)
      .get();
    
    const pets = snapshot.docs.map(doc => {
      const data = doc.data();
      return {
        id: doc.id,
        ...convertTimestamps(data),
      };
    });
    
    res.json({
      success: true,
      data: pets,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit)),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get single pet
// @route   GET /api/pets/:id
// @access  Public
exports.getPetById = async (req, res, next) => {
  try {
    const db = getFirestore();
    const petDoc = await db.collection('pets').doc(req.params.id).get();
    
    if (!petDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found',
      });
    }
    
    const petData = petDoc.data();
    res.json({
      success: true,
      data: {
        id: petDoc.id,
        ...convertTimestamps(petData),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get pets by category
// @route   GET /api/pets/category/:category
// @access  Public
exports.getPetsByCategory = async (req, res, next) => {
  try {
    const db = getFirestore();
    const { category } = req.params;
    
    const snapshot = await db
      .collection('pets')
      .where('category', '==', category)
      .get();
    
    const pets = snapshot.docs.map(doc => {
      const data = doc.data();
      return {
        id: doc.id,
        ...convertTimestamps(data),
      };
    });
    
    res.json({
      success: true,
      data: pets,
      count: pets.length,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Create pet
// @route   POST /api/pets
// @access  Private (Admin)
exports.createPet = async (req, res, next) => {
  try {
    const db = getFirestore();
    const petData = {
      ...req.body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    const docRef = await db.collection('pets').add(petData);
    const newPet = await docRef.get();
    const newPetData = newPet.data();
    
    res.status(201).json({
      success: true,
      data: {
        id: newPet.id,
        ...convertTimestamps(newPetData),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update pet
// @route   PUT /api/pets/:id
// @access  Private (Admin)
exports.updatePet = async (req, res, next) => {
  try {
    const db = getFirestore();
    const petRef = db.collection('pets').doc(req.params.id);
    
    const petDoc = await petRef.get();
    if (!petDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found',
      });
    }
    
    await petRef.update({
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    const updatedPet = await petRef.get();
    const petData = updatedPet.data();
    
    res.json({
      success: true,
      data: {
        id: updatedPet.id,
        ...convertTimestamps(petData),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Delete pet
// @route   DELETE /api/pets/:id
// @access  Private (Admin)
exports.deletePet = async (req, res, next) => {
  try {
    const db = getFirestore();
    const petRef = db.collection('pets').doc(req.params.id);
    
    const petDoc = await petRef.get();
    if (!petDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'Pet not found',
      });
    }
    
    await petRef.delete();
    
    res.json({
      success: true,
      message: 'Pet deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};

