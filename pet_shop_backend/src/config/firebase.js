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
    if (admin.apps.length > 0) {
      firestore = admin.firestore();
      auth = admin.auth();
      return;
    }

    if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      const credentialsPath = path.resolve(process.cwd(), process.env.GOOGLE_APPLICATION_CREDENTIALS);
      const serviceAccount = require(credentialsPath);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
    } else if (
      process.env.FIREBASE_PROJECT_ID &&
      process.env.FIREBASE_PRIVATE_KEY &&
      process.env.FIREBASE_CLIENT_EMAIL
    ) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        }),
      });
    } else {
      admin.initializeApp();
    }

    firestore = admin.firestore();
    auth = admin.auth();
  } catch (error) {
    throw new Error(`Firebase initialization error: ${error.message}`);
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
