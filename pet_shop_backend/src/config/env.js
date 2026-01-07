require('dotenv').config();

const validateEnv = () => {
  const hasServiceAccountFile = !!process.env.GOOGLE_APPLICATION_CREDENTIALS;
  const hasEnvCredentials = !!(
    process.env.FIREBASE_PROJECT_ID &&
    process.env.FIREBASE_PRIVATE_KEY &&
    process.env.FIREBASE_CLIENT_EMAIL
  );

  if (!hasServiceAccountFile && !hasEnvCredentials) {
    // Warning will be handled by Firebase initialization
  }
};

module.exports = { validateEnv };
