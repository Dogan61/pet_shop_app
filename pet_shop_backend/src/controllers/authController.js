const { getAuth, getFirestore } = require('../config/firebase');
const axios = require('axios');
const { sendSuccess, sendValidationError, sendServerError, sendUnauthorized } = require('../utils/responseHelper');
const { handleFirebaseAuthError, handleFirebaseRestApiError } = require('../utils/errorHelper');
const {
  getOrCreateUserByDecodedToken,
  getOrCreateUserFromRecordOrDecoded,
  createUserProfile,
  createOrUpdateSocialUserProfile,
} = require('../models/userModel');

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

    await createUserProfile(userRecord.uid, {
      uid: userRecord.uid,
      email: userRecord.email || email,
      fullName: fullName || userRecord.displayName || '',
      profileImage: userRecord.photoURL || '',
    });
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
        const userProfile = await getOrCreateUserFromRecordOrDecoded(auth, decodedToken, email);

        sendSuccess(
          res,
          {
            user: {
            id: decodedToken.uid,
            email: decodedToken.email || email,
            fullName: userProfile.fullName || '',
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
    const userProfile = await getOrCreateUserByDecodedToken(
      {
        uid: req.user.uid,
        email: req.user.email,
        name: req.user.displayName,
        picture: req.user.photoURL,
      },
      req.user.email
    );

    sendSuccess(res, userProfile, 'User profile retrieved');
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

    const userProfile = await createOrUpdateSocialUserProfile(decodedToken.uid, {
      uid: decodedToken.uid,
      email: decodedToken.email || '',
      fullName: decodedToken.name || '',
      profileImage: decodedToken.picture || '',
    });

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

    const userProfile = await createOrUpdateSocialUserProfile(userRecord.uid, {
      uid: userRecord.uid,
      email: userRecord.email || facebookUserInfo.email || '',
      fullName: userRecord.displayName || facebookUserInfo.name || '',
      profileImage: facebookUserInfo.picture?.data?.url || userRecord.photoURL || '',
    });
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
