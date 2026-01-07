const { getFirestore } = require('../config/firebase');
const { createUserProfileData } = require('../utils/userHelper');
const { sendSuccess } = require('../utils/responseHelper');
const admin = require('firebase-admin');

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
exports.getProfile = async (req, res, next) => {
  try {
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(req.user.uid).get();

    if (!userDoc.exists) {
      const userData = createUserProfileData({
        uid: req.user.uid,
        email: req.user.email || '',
        fullName: req.user.displayName || '',
        profileImage: req.user.photoURL || '',
      });

      await db.collection('users').doc(req.user.uid).set(userData);
      return sendSuccess(res, { id: req.user.uid, ...userData }, 'User profile retrieved');
    }

    sendSuccess(res, { id: userDoc.id, ...userDoc.data() }, 'User profile retrieved');
  } catch (error) {
    next(error);
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
exports.updateProfile = async (req, res, next) => {
  try {
    const db = getFirestore();
    const userRef = db.collection('users').doc(req.user.uid);

    const updateData = {
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await userRef.update(updateData);
    const updatedUser = await userRef.get();

    sendSuccess(res, { id: updatedUser.id, ...updatedUser.data() }, 'Profile updated successfully');
  } catch (error) {
    next(error);
  }
};
