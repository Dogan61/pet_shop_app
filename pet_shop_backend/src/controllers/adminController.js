const { getFirestore } = require('../config/firebase');
const { sendSuccess } = require('../utils/responseHelper');

// @desc    Check if current user is admin
// @route   GET /api/admin/check
// @access  Private
// Note: Admin status is stored in Firestore users collection (isAdmin: true)
// To set admin: Go to Firestore Console → users collection → user document → Add field: isAdmin = true
exports.checkAdmin = async (req, res, next) => {
  try {
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(req.user.uid).get();

    let isAdminFromFirestore = false;
    if (userDoc.exists) {
      const userData = userDoc.data();
      isAdminFromFirestore = userData.isAdmin === true;
    }

    sendSuccess(res, {
      uid: req.user.uid,
      email: req.user.email,
      admin: isAdminFromFirestore,
      isAdmin: isAdminFromFirestore,
    });
  } catch (error) {
    next(error);
  }
};
