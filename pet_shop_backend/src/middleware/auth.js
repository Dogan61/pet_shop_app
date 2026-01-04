/**
 * Firebase Authentication Middleware
 * Verifies Firebase ID token from Authorization header
 */
const { getAuth } = require('../config/firebase');

const authenticate = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'No token provided',
      });
    }

    const auth = getAuth();
    const decodedToken = await auth.verifyIdToken(token);

    req.user = {
      uid: decodedToken.uid,
      id: decodedToken.uid, // For backward compatibility
      email: decodedToken.email,
      displayName: decodedToken.name,
      photoURL: decodedToken.picture,
      admin: decodedToken.admin || false, // Custom claim for admin role
      ...decodedToken,
    };

    next();
  } catch (error) {
    console.error('Auth middleware error:', error.message);
    res.status(401).json({
      success: false,
      message: 'Invalid token',
    });
  }
};

module.exports = { authenticate };


