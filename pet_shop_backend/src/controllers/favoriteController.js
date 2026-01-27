const { sendSuccess, sendValidationError, sendNotFound, sendForbidden } = require('../utils/responseHelper');
const {
  getFavoritesWithPetsByUserId,
  addFavoriteForUser,
  removeFavoriteByIdForUser,
} = require('../models/favoriteModel');

// @desc    Get user favorites
// @route   GET /api/favorites
// @access  Private
exports.getFavorites = async (req, res, next) => {
  try {
    const favoritesWithPets = await getFavoritesWithPetsByUserId(req.user.uid);

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
    const { petId } = req.body;

    if (!petId) {
      return sendValidationError(res, 'Please provide pet ID');
    }

    const result = await addFavoriteForUser(req.user.uid, petId);

    if (result.error === 'PET_NOT_FOUND') {
      return sendNotFound(res, 'Pet not found');
    }

    if (result.error === 'ALREADY_FAVORITE') {
      return sendValidationError(res, 'Pet already in favorites');
    }

    sendSuccess(
      res,
      result,
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
    const result = await removeFavoriteByIdForUser(req.params.id, req.user.uid);

    if (result.error === 'FAVORITE_NOT_FOUND') {
      return sendNotFound(res, 'Favorite not found');
    }

    if (result.error === 'FORBIDDEN') {
      return sendForbidden(res, 'Not authorized');
    }

    sendSuccess(res, null, 'Favorite removed successfully');
  } catch (error) {
    next(error);
  }
};
