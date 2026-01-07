const { getAuth, getFirestore } = require('../config/firebase');
const axios = require('axios');
const { createUserProfileData, createOrUpdateUserProfile } = require('../utils/userHelper');
const { sendSuccess, sendValidationError, sendServerError, sendUnauthorized } = require('../utils/responseHelper');
const { handleFirebaseAuthError, handleFirebaseRestApiError } = require('../utils/errorHelper');

// @desc    Register user
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res, next) => {
  try {
    const { fullName, email, password } = req.body;

    if (!email || !password) {
      return sendValidationError(res, 'Email and password are required');
    }

    const auth = getAuth();
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: fullName,
      emailVerified: false,
    });

    const db = getFirestore();
    const userData = createUserProfileData({
      uid: userRecord.uid,
      email: userRecord.email || email,
      fullName: fullName || userRecord.displayName || '',
      profileImage: userRecord.photoURL || '',
    });

    await db.collection('users').doc(userRecord.uid).set(userData);
    const customToken = await auth.createCustomToken(userRecord.uid);

    sendSuccess(
      res,
      {
        user: {
          id: userRecord.uid,
          email: userRecord.email,
          fullName: fullName || userRecord.displayName || '',
        },
        token: customToken,
      },
      'Registration successful',
      201
    );
  } catch (error) {
    if (handleFirebaseAuthError(error, res)) {
      return;
    }
    next(error);
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return sendValidationError(res, 'Email and password are required');
    }

    const webApiKey = process.env.FIREBASE_WEB_API_KEY;
    if (!webApiKey) {
      return sendServerError(res, 'Server configuration error. Please contact support.', 'CONFIGURATION_ERROR');
    }

    const auth = getAuth();

    try {
      const response = await axios.post(
        `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${webApiKey}`,
        {
          email,
          password,
          returnSecureToken: true,
        }
      );

      if (response.data && response.data.idToken) {
        const decodedToken = await auth.verifyIdToken(response.data.idToken);
        const db = getFirestore();
        const userDoc = await db.collection('users').doc(decodedToken.uid).get();

        let userData;
        if (userDoc.exists) {
          userData = userDoc.data();
        } else {
          let userRecord = null;
          try {
            userRecord = await auth.getUser(decodedToken.uid);
          } catch (err) {
            // User record not found, continue with decoded token data
          }

          userData = createUserProfileData({
            uid: decodedToken.uid,
            email: decodedToken.email || email,
            fullName: decodedToken.name || userRecord?.displayName || '',
            profileImage: decodedToken.picture || userRecord?.photoURL || '',
          });

          await db.collection('users').doc(decodedToken.uid).set(userData);
        }

        sendSuccess(
          res,
          {
            user: {
              id: decodedToken.uid,
              email: decodedToken.email || email,
              fullName: userData.fullName || '',
            },
            token: response.data.idToken,
          },
          'Login successful'
        );
        return;
      }
    } catch (apiError) {
      if (handleFirebaseRestApiError(apiError, res)) {
        return;
      }

      return sendServerError(
        res,
        'Authentication service temporarily unavailable. Please try again later.',
        'SERVICE_UNAVAILABLE'
      );
    }
  } catch (error) {
    if (handleFirebaseAuthError(error, res)) {
      return;
    }
    next(error);
  }
};

// @desc    Get current user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res, next) => {
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

// @desc    Logout user
// @route   POST /api/auth/logout
// @access  Private
exports.logout = async (req, res, next) => {
  try {
    sendSuccess(res, null, 'Logout successful');
  } catch (error) {
    next(error);
  }
};

// @desc    Login with Google
// @route   POST /api/auth/google
// @access  Public
exports.loginWithGoogle = async (req, res, next) => {
  try {
    const { idToken } = req.body;

    if (!idToken) {
      return sendValidationError(res, 'Google ID token is required');
    }

    const auth = getAuth();
    let decodedToken;
    try {
      decodedToken = await auth.verifyIdToken(idToken);
    } catch (error) {
      return sendUnauthorized(res, 'Invalid Google ID token');
    }

    const db = getFirestore();
    const userData = createUserProfileData({
      uid: decodedToken.uid,
      email: decodedToken.email || '',
      fullName: decodedToken.name || '',
      profileImage: decodedToken.picture || '',
    });

    const userProfile = await createOrUpdateUserProfile(db, decodedToken.uid, userData);

    sendSuccess(
      res,
      {
        user: {
          id: decodedToken.uid,
          email: decodedToken.email || '',
          fullName: userProfile.fullName || decodedToken.name || '',
        },
        token: idToken,
      },
      'Google login successful'
    );
  } catch (error) {
    next(error);
  }
};

// @desc    Login with Facebook
// @route   POST /api/auth/facebook
// @access  Public
exports.loginWithFacebook = async (req, res, next) => {
  try {
    const { accessToken } = req.body;

    if (!accessToken) {
      return sendValidationError(res, 'Facebook access token is required');
    }

    const auth = getAuth();
    let facebookUserInfo;
    try {
      const response = await axios.get(
        `https://graph.facebook.com/me?fields=id,name,email,picture&access_token=${accessToken}`
      );
      facebookUserInfo = response.data;
    } catch (error) {
      return sendUnauthorized(res, 'Invalid Facebook access token');
    }

    let userRecord;
    if (facebookUserInfo.email) {
      try {
        userRecord = await auth.getUserByEmail(facebookUserInfo.email);
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          userRecord = await auth.createUser({
            email: facebookUserInfo.email,
            displayName: facebookUserInfo.name,
            photoURL: facebookUserInfo.picture?.data?.url || '',
            emailVerified: true,
          });
        } else {
          throw error;
        }
      }
    } else {
      const placeholderEmail = `${facebookUserInfo.id}@facebook.temp`;
      try {
        userRecord = await auth.getUserByEmail(placeholderEmail);
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          userRecord = await auth.createUser({
            uid: `facebook_${facebookUserInfo.id}`,
            email: placeholderEmail,
            displayName: facebookUserInfo.name,
            photoURL: facebookUserInfo.picture?.data?.url || '',
            emailVerified: false,
          });
        } else {
          throw error;
        }
      }
    }

    const db = getFirestore();
    const userData = createUserProfileData({
      uid: userRecord.uid,
      email: userRecord.email || facebookUserInfo.email || '',
      fullName: userRecord.displayName || facebookUserInfo.name || '',
      profileImage: facebookUserInfo.picture?.data?.url || userRecord.photoURL || '',
    });

    const userProfile = await createOrUpdateUserProfile(db, userRecord.uid, userData);
    const customToken = await auth.createCustomToken(userRecord.uid);

    sendSuccess(
      res,
      {
        user: {
          id: userRecord.uid,
          email: userRecord.email || facebookUserInfo.email || '',
          fullName: userProfile.fullName || userRecord.displayName || facebookUserInfo.name || '',
        },
        token: customToken,
      },
      'Facebook login successful'
    );
  } catch (error) {
    next(error);
  }
};
