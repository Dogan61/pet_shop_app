const { sendUnauthorized, sendForbidden } = require('../utils/responseHelper');

/**
 * Admin Middleware
 * Checks if user has admin role from Firestore users collection
 * Must be used after authenticate middleware
 */
const isAdmin = async (req, res, next) => {
  try {
    if (!req.user) {
      return sendUnauthorized(res, 'Authentication required');
    }

    if (req.user.admin === true) {
      next();
    } else {
      return sendForbidden(res, 'Access denied. Admin privileges required.');
    }
  } catch (error) {
    return sendForbidden(res, 'Access denied. Admin privileges required.');
  }
};

module.exports = { isAdmin };
