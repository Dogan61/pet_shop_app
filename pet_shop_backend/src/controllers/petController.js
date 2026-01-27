const { sendSuccess, sendNotFound } = require('../utils/responseHelper');
const {
  getPets,
  getPetById,
  getPetsByCategory,
  createPet,
  updatePet,
  deletePet,
} = require('../models/petModel');

// @desc    Get all pets
// @route   GET /api/pets
// @access  Public
exports.getAllPets = async (req, res, next) => {
  try {
    const { category, page = 1, limit = 10 } = req.query;

    const result = await getPets({ category, page, limit });

    sendSuccess(res, result);
  } catch (error) {
    next(error);
  }
};

// @desc    Get single pet
// @route   GET /api/pets/:id
// @access  Public
exports.getPetById = async (req, res, next) => {
  try {
    const pet = await getPetById(req.params.id);

    if (!pet) {
      return sendNotFound(res, 'Pet not found');
    }

    sendSuccess(res, pet);
  } catch (error) {
    next(error);
  }
};

// @desc    Get pets by category
// @route   GET /api/pets/category/:category
// @access  Public
exports.getPetsByCategory = async (req, res, next) => {
  try {
    const { category } = req.params;

    const pets = await getPetsByCategory(category);

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
    const pet = await createPet(req.body);

    sendSuccess(
      res,
      pet,
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
    const pet = await updatePet(req.params.id, req.body);

    if (!pet) {
      return sendNotFound(res, 'Pet not found');
    }

    sendSuccess(res, pet);
  } catch (error) {
    next(error);
  }
};

// @desc    Delete pet
// @route   DELETE /api/pets/:id
// @access  Private (Admin)
exports.deletePet = async (req, res, next) => {
  try {
    const deleted = await deletePet(req.params.id);

    if (!deleted) {
      return sendNotFound(res, 'Pet not found');
    }

    sendSuccess(res, null, 'Pet deleted successfully');
  } catch (error) {
    next(error);
  }
};
