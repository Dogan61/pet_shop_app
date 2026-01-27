const { createUserProfileData } = require('../utils/userHelper');
const { sendSuccess } = require('../utils/responseHelper');
const { getUserById, createUserProfile, updateUserProfile } = require('../models/userModel');

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
exports.getProfile = async (req, res, next) => {
  try {
    const existingUser = await getUserById(req.user.uid);

    if (!existingUser) {
      const userData = createUserProfileData({
        uid: req.user.uid,
        email: req.user.email || '',
        fullName: req.user.displayName || '',
        profileImage: req.user.photoURL || '',
      });

      const createdUser = await createUserProfile(req.user.uid, userData);
      return sendSuccess(res, createdUser, 'User profile retrieved');
    }

    sendSuccess(res, existingUser, 'User profile retrieved');
  } catch (error) {
    next(error);
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
exports.updateProfile = async (req, res, next) => {
  try {
    const updatedUser = await updateUserProfile(req.user.uid, req.body);

    sendSuccess(res, updatedUser, 'Profile updated successfully');
  } catch (error) {
    next(error);
  }
};
