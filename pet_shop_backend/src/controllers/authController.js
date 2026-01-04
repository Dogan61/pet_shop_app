const { getAuth, getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const axios = require('axios');

// @desc    Register user
// @route   POST /api/auth/register
// @access  Public
exports.register = async (req, res, next) => {
  try {
    const { fullName, email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email and password are required',
        error: 'VALIDATION_ERROR',
      });
    }

    // Create user in Firebase Authentication
    const auth = getAuth();
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: fullName,
      emailVerified: false,
    });

    // Create user profile in Firestore
    const db = getFirestore();
    const userData = {
      uid: userRecord.uid,
      email: userRecord.email || email,
      fullName: fullName || userRecord.displayName || '',
      phone: '',
      address: '',
      profileImage: userRecord.photoURL || '',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('users').doc(userRecord.uid).set(userData);

    // Generate custom token for the user
    // Note: Client should sign in with email/password to get ID token
    const customToken = await auth.createCustomToken(userRecord.uid);

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      data: {
        user: {
          id: userRecord.uid,
          email: userRecord.email,
          fullName: fullName || userRecord.displayName || '',
        },
        token: customToken,
      },
    });
  } catch (error) {
    // Handle Firebase Auth errors
    if (error.code === 'auth/email-already-exists') {
      return res.status(400).json({
        success: false,
        message: 'This email is already registered',
        error: 'EMAIL_ALREADY_EXISTS',
      });
    }
    if (error.code === 'auth/invalid-email') {
      return res.status(400).json({
        success: false,
        message: 'Invalid email address format',
        error: 'INVALID_EMAIL',
      });
    }
    if (error.code === 'auth/weak-password') {
      return res.status(400).json({
        success: false,
        message: 'Password must be at least 6 characters long',
        error: 'WEAK_PASSWORD',
      });
    }
    console.error('Register error:', error);
    next(error);
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Validate email & password
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email and password are required',
        error: 'VALIDATION_ERROR',
      });
    }

    // Get Firebase project ID from service account or env
    let projectId;
    if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      const credentialsPath = require('path').resolve(process.cwd(), process.env.GOOGLE_APPLICATION_CREDENTIALS);
      const serviceAccount = require(credentialsPath);
      projectId = serviceAccount.project_id;
    } else if (process.env.FIREBASE_PROJECT_ID) {
      projectId = process.env.FIREBASE_PROJECT_ID;
    } else {
      // Try to get from initialized app
      const app = admin.apps[0];
      if (app) {
        projectId = app.options.projectId;
      }
    }

    if (!projectId) {
      return res.status(500).json({
        success: false,
        message: 'Server configuration error. Please contact support.',
        error: 'CONFIGURATION_ERROR',
      });
    }

    // Use Firebase REST API to verify email/password
    // Firebase Identity Toolkit API
    let auth;
    try {
      auth = getAuth();
    } catch (error) {
      console.error('Firebase Auth initialization error:', error);
      return res.status(500).json({
        success: false,
        message: 'Server configuration error. Please contact support.',
        error: 'CONFIGURATION_ERROR',
      });
    }
    
    // First, try to get user by email to check if user exists
    // Note: We'll skip this check and let Firebase REST API handle it
    // This avoids unnecessary Firebase Admin SDK calls
    let userRecord = null;

    // Since Firebase Admin SDK cannot verify passwords directly,
    // we need to use Firebase REST API (Identity Toolkit)
    // However, we need the Web API Key for this
    // Alternative: Use Firebase Admin SDK to create a custom token
    // But we still need to verify the password somehow
    
    // For now, we'll use a workaround:
    // 1. Get user by email (already done)
    // 2. Create a custom token (this doesn't verify password, but allows client to sign in)
    // 3. Client should verify password on their side using Firebase Client SDK
    
    // Better approach: Use Firebase REST API with Web API Key
    // But since we don't have Web API Key, we'll use a different approach:
    // Generate custom token and let client verify password
    
    // Actually, the best approach is to use Firebase REST API
    // We need FIREBASE_WEB_API_KEY environment variable
    const webApiKey = process.env.FIREBASE_WEB_API_KEY;
    
    if (!webApiKey) {
      // If Web API Key is not available, we cannot verify password
      console.error('FIREBASE_WEB_API_KEY is not configured');
      return res.status(500).json({
        success: false,
        message: 'Server configuration error. Please contact support.',
        error: 'CONFIGURATION_ERROR',
      });
    }

    // Use Firebase REST API to verify password
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
        // Verify the ID token to get user info
        const decodedToken = await auth.verifyIdToken(response.data.idToken);
        
        // Get user profile from Firestore
        const db = getFirestore();
        const userDoc = await db.collection('users').doc(decodedToken.uid).get();
        
        let userData;
        if (userDoc.exists) {
          userData = userDoc.data();
        } else {
          // Get user record from Firebase Auth for display name
          try {
            userRecord = await auth.getUser(decodedToken.uid);
          } catch (err) {
            console.error('Error getting user record:', err);
          }
          
          // Create user profile if doesn't exist
          userData = {
            uid: decodedToken.uid,
            email: decodedToken.email || email,
            fullName: decodedToken.name || userRecord?.displayName || '',
            phone: '',
            address: '',
            profileImage: decodedToken.picture || userRecord?.photoURL || '',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          };
          await db.collection('users').doc(decodedToken.uid).set(userData);
        }

        res.json({
          success: true,
          message: 'Login successful',
          data: {
            user: {
              id: decodedToken.uid,
              email: decodedToken.email || email,
              fullName: userData.fullName || userRecord?.displayName || '',
            },
            token: response.data.idToken,
          },
        });
        return;
      }
    } catch (apiError) {
      // Handle Firebase REST API errors
      if (apiError.response && apiError.response.data) {
        const errorData = apiError.response.data;
        if (errorData.error) {
          const errorCode = errorData.error.message;
          if (errorCode.includes('INVALID_PASSWORD') || errorCode.includes('EMAIL_NOT_FOUND')) {
            return res.status(401).json({
              success: false,
              message: 'Invalid email or password',
              error: 'INVALID_CREDENTIALS',
            });
          }
          if (errorCode.includes('USER_DISABLED')) {
            return res.status(403).json({
              success: false,
              message: 'Your account has been disabled. Please contact support.',
              error: 'USER_DISABLED',
            });
          }
          if (errorCode.includes('TOO_MANY_ATTEMPTS_TRY_LATER')) {
            return res.status(429).json({
              success: false,
              message: 'Too many failed login attempts. Please try again later.',
              error: 'TOO_MANY_ATTEMPTS',
            });
          }
        }
      }
      
      // If it's a network error or other unexpected error, log it
      console.error('Firebase REST API error:', apiError.message);
      if (apiError.response) {
        console.error('Response data:', apiError.response.data);
      }
      
      // Return a user-friendly error instead of throwing
      return res.status(500).json({
        success: false,
        message: 'Authentication service temporarily unavailable. Please try again later.',
        error: 'SERVICE_UNAVAILABLE',
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    
    // Handle Firebase Auth errors
    if (error.code === 'auth/user-not-found') {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password',
        error: 'INVALID_CREDENTIALS',
      });
    }
    if (error.code === 'auth/invalid-email') {
      return res.status(400).json({
        success: false,
        message: 'Invalid email address format',
        error: 'INVALID_EMAIL',
      });
    }
    
    // For any other unexpected errors, return a user-friendly message
    return res.status(500).json({
      success: false,
      message: 'An unexpected error occurred. Please try again later.',
      error: 'INTERNAL_ERROR',
    });
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
      // Create user profile if doesn't exist
      const userData = {
        uid: req.user.uid,
        email: req.user.email || '',
        fullName: req.user.displayName || '',
        phone: '',
        address: '',
        profileImage: req.user.photoURL || '',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      await db.collection('users').doc(req.user.uid).set(userData);
      
      return res.json({
        success: true,
        message: 'User profile retrieved',
        data: {
          id: req.user.uid,
          ...userData,
        },
      });
    }
    
    res.json({
      success: true,
      message: 'User profile retrieved',
      data: {
        id: userDoc.id,
        ...userDoc.data(),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Logout user
// @route   POST /api/auth/logout
// @access  Private
exports.logout = async (req, res, next) => {
  try {
    // In a real app, you might want to blacklist the token
    // For now, we'll just return success
    res.json({
      success: true,
      message: 'Logout successful',
    });
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
      return res.status(400).json({
        success: false,
        message: 'Google ID token is required',
        error: 'VALIDATION_ERROR',
      });
    }

    const auth = getAuth();
    
    // Verify the Google ID token
    let decodedToken;
    try {
      decodedToken = await auth.verifyIdToken(idToken);
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid Google ID token',
        error: 'INVALID_TOKEN',
      });
    }

    // Check if user exists in Firestore
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(decodedToken.uid).get();

    let userData;
    if (userDoc.exists) {
      userData = userDoc.data();
    } else {
      // Create user profile if doesn't exist
      userData = {
        uid: decodedToken.uid,
        email: decodedToken.email || '',
        fullName: decodedToken.name || '',
        phone: '',
        address: '',
        profileImage: decodedToken.picture || '',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      await db.collection('users').doc(decodedToken.uid).set(userData);
    }

    // Return Firebase ID token (which is the same as Google ID token in this case)
    res.json({
      success: true,
      message: 'Google login successful',
      data: {
        user: {
          id: decodedToken.uid,
          email: decodedToken.email || '',
          fullName: userData.fullName || decodedToken.name || '',
        },
        token: idToken, // Use the Google ID token as the auth token
      },
    });
  } catch (error) {
    console.error('Google login error:', error);
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
      return res.status(400).json({
        success: false,
        message: 'Facebook access token is required',
        error: 'VALIDATION_ERROR',
      });
    }

    // Verify Facebook access token and get user info
    // Note: In production, you should verify the token with Facebook Graph API
    // For now, we'll use Firebase to create/authenticate the user
    const auth = getAuth();
    
    // Get user info from Facebook Graph API
    let facebookUserInfo;
    try {
      const response = await axios.get(
        `https://graph.facebook.com/me?fields=id,name,email,picture&access_token=${accessToken}`
      );
      facebookUserInfo = response.data;
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Invalid Facebook access token',
        error: 'INVALID_TOKEN',
      });
    }

    // Check if user exists by email (if email is available)
    let userRecord;
    if (facebookUserInfo.email) {
      try {
        userRecord = await auth.getUserByEmail(facebookUserInfo.email);
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          // Create new user
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
      // If no email, create user with Facebook ID as UID
      // Note: Firebase requires email, so we'll use a placeholder
      // In production, you might want to handle this differently
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

    // Create or update user profile in Firestore
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(userRecord.uid).get();

    let userData;
    if (userDoc.exists) {
      userData = userDoc.data();
      // Update profile image if available
      if (facebookUserInfo.picture?.data?.url) {
        await db.collection('users').doc(userRecord.uid).update({
          profileImage: facebookUserInfo.picture.data.url,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        userData.profileImage = facebookUserInfo.picture.data.url;
      }
    } else {
      // Create user profile
      userData = {
        uid: userRecord.uid,
        email: userRecord.email || facebookUserInfo.email || '',
        fullName: userRecord.displayName || facebookUserInfo.name || '',
        phone: '',
        address: '',
        profileImage: facebookUserInfo.picture?.data?.url || userRecord.photoURL || '',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      await db.collection('users').doc(userRecord.uid).set(userData);
    }

    // Generate custom token for the user
    const customToken = await auth.createCustomToken(userRecord.uid);

    res.json({
      success: true,
      message: 'Facebook login successful',
      data: {
        user: {
          id: userRecord.uid,
          email: userRecord.email || facebookUserInfo.email || '',
          fullName: userData.fullName || userRecord.displayName || facebookUserInfo.name || '',
        },
        token: customToken,
      },
    });
  } catch (error) {
    console.error('Facebook login error:', error);
    next(error);
  }
};


