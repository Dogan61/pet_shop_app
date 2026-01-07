/**
 * Firebase Authentication Middleware
 * Verifies Firebase ID token from Authorization header
 * Checks admin status from Firestore users collection
 */
const { getAuth, getFirestore } = require('../config/firebase');
const { sendUnauthorized } = require('../utils/responseHelper');

const authenticate = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      return sendUnauthorized(res, 'No token provided');
    }

    const auth = getAuth();
    const decodedToken = await auth.verifyIdToken(token);

    // Check admin status from Firestore
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(decodedToken.uid).get();

    let isAdmin = false;
    if (userDoc.exists) {
      const userData = userDoc.data();
      isAdmin = userData.isAdmin === true;
    }

    req.user = {
      uid: decodedToken.uid,
      id: decodedToken.uid,
      email: decodedToken.email,
      displayName: decodedToken.name,
      photoURL: decodedToken.picture,
      admin: isAdmin,
      ...decodedToken,
    };

    next();
  } catch (error) {
    sendUnauthorized(res, 'Invalid token');
  }
};

module.exports = { authenticate };
