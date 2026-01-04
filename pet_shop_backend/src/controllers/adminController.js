const { getAuth } = require('../config/firebase');

// @desc    Set user as admin
// @route   POST /api/admin/set-admin
// @access  Private (Admin)
exports.setAdmin = async (req, res, next) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({
        success: false,
        message: 'Email is required',
      });
    }
    
    const auth = getAuth();
    const user = await auth.getUserByEmail(email);
    
    // Set custom claim
    await auth.setCustomUserClaims(user.uid, { admin: true });
    
    res.json({
      success: true,
      message: `Admin role granted to ${email}. User must sign out and sign in again for changes to take effect.`,
      data: {
        uid: user.uid,
        email: user.email,
      },
    });
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }
    next(error);
  }
};

// @desc    Remove admin role
// @route   POST /api/admin/remove-admin
// @access  Private (Admin)
exports.removeAdmin = async (req, res, next) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({
        success: false,
        message: 'Email is required',
      });
    }
    
    const auth = getAuth();
    const user = await auth.getUserByEmail(email);
    
    // Remove admin custom claim
    await auth.setCustomUserClaims(user.uid, { admin: false });
    
    res.json({
      success: true,
      message: `Admin role removed from ${email}. User must sign out and sign in again for changes to take effect.`,
      data: {
        uid: user.uid,
        email: user.email,
      },
    });
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }
    next(error);
  }
};

// @desc    Get all admins
// @route   GET /api/admin/admins
// @access  Private (Admin)
exports.getAdmins = async (req, res, next) => {
  try {
    const auth = getAuth();
    const listUsersResult = await auth.listUsers(1000); // Get up to 1000 users
    
    const admins = [];
    
    // Check each user for admin claim
    for (const userRecord of listUsersResult.users) {
      const user = await auth.getUser(userRecord.uid);
      if (user.customClaims && user.customClaims.admin === true) {
        admins.push({
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoURL: user.photoURL,
        });
      }
    }
    
    res.json({
      success: true,
      data: admins,
      count: admins.length,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Check if current user is admin
// @route   GET /api/admin/check
// @access  Private
exports.checkAdmin = async (req, res, next) => {
  try {
    res.json({
      success: true,
      isAdmin: req.user.admin === true,
      data: {
        uid: req.user.uid,
        email: req.user.email,
        admin: req.user.admin || false,
      },
    });
  } catch (error) {
    next(error);
  }
};

