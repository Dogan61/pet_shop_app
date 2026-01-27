const { sendSuccess } = require('../utils/responseHelper');
const { getAdminStatusForUser } = require('../models/adminModel');

// @desc    Check if current user is admin
// @route   GET /api/admin/check
// @access  Private
// Note: Admin status is stored in Firestore users collection (isAdmin: true)
// To set admin: Go to Firestore Console → users collection → user document → Add field: isAdmin = true
exports.checkAdmin = async (req, res, next) => {
  try {
    const { uid, isAdmin } = await getAdminStatusForUser(req.user.uid);

    sendSuccess(res, {
      uid,
      email: req.user.email,
      admin: isAdmin,
      isAdmin,
    });
  } catch (error) {
    next(error);
  }
};
