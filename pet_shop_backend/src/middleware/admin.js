const { authenticate } = require('./auth');

/**
 * Admin Middleware
 * Checks if user has admin role via Firebase Custom Claims
 * Must be used after authenticate middleware
 */
const isAdmin = async (req, res, next) => {
  try {
    // Check if user is authenticated
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required',
      });
    }

    // Check if user has admin role
    if (req.user.admin === true) {
      next();
    } else {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Admin privileges required.',
      });
    }
  } catch (error) {
    console.error('Admin middleware error:', error.message);
    res.status(403).json({
      success: false,
      message: 'Access denied. Admin privileges required.',
    });
  }
};

module.exports = { isAdmin };

