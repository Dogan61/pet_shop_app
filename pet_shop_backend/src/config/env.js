require('dotenv').config();

const requiredEnvVars = [
  // Firebase configuration (at least one method required)
  // Option 1: Service account key file path
  // 'GOOGLE_APPLICATION_CREDENTIALS',
  // Option 2: Firebase credentials as environment variables
  // 'FIREBASE_PROJECT_ID',
  // 'FIREBASE_PRIVATE_KEY',
  // 'FIREBASE_CLIENT_EMAIL',
];

const validateEnv = () => {
  const missing = requiredEnvVars.filter((key) => !process.env[key]);

  if (missing.length > 0) {
    console.warn(`⚠️  Optional environment variables not set: ${missing.join(', ')}`);
    console.log('ℹ️  Firebase will use default credentials or service account file');
  }

  // Check if at least one Firebase auth method is configured
  const hasServiceAccountFile = !!process.env.GOOGLE_APPLICATION_CREDENTIALS;
  const hasEnvCredentials = !!(
    process.env.FIREBASE_PROJECT_ID &&
    process.env.FIREBASE_PRIVATE_KEY &&
    process.env.FIREBASE_CLIENT_EMAIL
  );

  if (!hasServiceAccountFile && !hasEnvCredentials) {
    console.warn('⚠️  No Firebase credentials found. Using default credentials or mock data.');
  }
};

module.exports = { validateEnv };


