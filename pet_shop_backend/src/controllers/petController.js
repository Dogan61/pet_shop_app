const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');
const { sendSuccess, sendNotFound } = require('../utils/responseHelper');

// @desc    Get all pets
// @route   GET /api/pets
// @access  Public
exports.getAllPets = async (req, res, next) => {
  try {
    const db = getFirestore();
    const { category, page = 1, limit = 10 } = req.query;

    let query = db.collection('pets');

    if (category && category !== 'all') {
      query = query.where('category', '==', category);
    }

    const countSnapshot = await query.get();
    const total = countSnapshot.size;

    const startIndex = (parseInt(page) - 1) * parseInt(limit);
    const snapshot = await query
      .orderBy('createdAt', 'desc')
      .limit(parseInt(limit))
      .offset(startIndex)
      .get();

    const pets = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...convertTimestamps(doc.data()),
    }));

    sendSuccess(res, {
      pets,
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
      return sendNotFound(res, 'Pet not found');
    }

    sendSuccess(res, {
      id: petDoc.id,
      ...convertTimestamps(petDoc.data()),
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

    const snapshot = await db.collection('pets').where('category', '==', category).get();

    const pets = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...convertTimestamps(doc.data()),
    }));

    sendSuccess(res, { pets, count: pets.length });
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

    sendSuccess(
      res,
      {
        id: newPet.id,
        ...convertTimestamps(newPet.data()),
      },
      'Pet created successfully',
      201
    );
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
      return sendNotFound(res, 'Pet not found');
    }

    await petRef.update({
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const updatedPet = await petRef.get();

    sendSuccess(res, {
      id: updatedPet.id,
      ...convertTimestamps(updatedPet.data()),
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
      return sendNotFound(res, 'Pet not found');
    }

    await petRef.delete();

    sendSuccess(res, null, 'Pet deleted successfully');
  } catch (error) {
    next(error);
  }
};
