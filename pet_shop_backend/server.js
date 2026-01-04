require('dotenv').config();
const app = require('./src/app');
const { initializeFirebase } = require('./src/config/firebase');

const PORT = process.env.PORT || 5001;

// Initialize Firebase Admin SDK
initializeFirebase();

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔥 Firebase Firestore initialized`);
});


