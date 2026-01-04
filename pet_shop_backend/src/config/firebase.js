const admin = require('firebase-admin');
const path = require('path');

let firestore;
let auth;

/**
 * Initialize Firebase Admin SDK
 * Requires GOOGLE_APPLICATION_CREDENTIALS environment variable
 * pointing to the Firebase service account key JSON file
 */
const initializeFirebase = () => {
  try {
    // Check if Firebase is already initialized
    if (admin.apps.length > 0) {
      console.log('✅ Firebase already initialized');
      firestore = admin.firestore();
      auth = admin.auth();
      return;
    }

    // Initialize Firebase Admin SDK
    // Option 1: Using service account key file (recommended for production)
    if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      // Resolve path relative to project root (where server.js is located)
      // This makes the path dynamic and works on any machine
      const credentialsPath = path.resolve(process.cwd(), process.env.GOOGLE_APPLICATION_CREDENTIALS);
      const serviceAccount = require(credentialsPath);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log('✅ Firebase initialized with service account');
    }
    // Option 2: Using environment variables (alternative)
    else if (process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_PRIVATE_KEY && process.env.FIREBASE_CLIENT_EMAIL) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        }),
      });
      console.log('✅ Firebase initialized with environment variables');
    }
    // Option 3: Using default credentials (for Firebase emulator or GCP)
    else {
      admin.initializeApp();
      console.log('✅ Firebase initialized with default credentials');
    }

    firestore = admin.firestore();
    auth = admin.auth();

    console.log('🔥 Firebase Firestore and Auth ready');
  } catch (error) {
    console.error('❌ Firebase initialization error:', error.message);
    console.log('⚠️  Server will continue with mock data');
  }
};

/**
 * Get Firestore instance
 */
const getFirestore = () => {
  if (!firestore) {
    throw new Error('Firebase not initialized. Call initializeFirebase() first.');
  }
  return firestore;
};

/**
 * Get Auth instance
 */
const getAuth = () => {
  if (!auth) {
    throw new Error('Firebase not initialized. Call initializeFirebase() first.');
  }
  return auth;
};

module.exports = {
  initializeFirebase,
  getFirestore,
  getAuth,
};

