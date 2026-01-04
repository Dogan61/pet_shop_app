require('dotenv').config();
const { getAuth } = require('../src/config/firebase');

/**
 * Script to set a user as admin
 * Usage: node scripts/setAdmin.js user@example.com
 */
const setAdmin = async (email) => {
  try {
    console.log(`🔍 Looking for user: ${email}`);
    
    const auth = getAuth();
    
    // Find user by email
    const user = await auth.getUserByEmail(email);
    
    console.log(`✅ User found: ${user.email} (${user.uid})`);
    
    // Set custom claim
    await auth.setCustomUserClaims(user.uid, { admin: true });
    
    console.log(`✅ Admin role granted to ${email} (${user.uid})`);
    console.log('⚠️  User must sign out and sign in again for changes to take effect');
    console.log('');
    console.log('📝 Next steps:');
    console.log('   1. User should sign out from the app');
    console.log('   2. User should sign in again');
    console.log('   3. New token will include admin claim');
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      console.error(`❌ User not found: ${email}`);
      console.log('💡 Make sure the user has registered and signed in at least once');
    } else {
      console.error('❌ Error:', error.message);
    }
    process.exit(1);
  }
};

// Get email from command line argument
const email = process.argv[2];

if (!email) {
  console.error('❌ Please provide an email address');
  console.log('');
  console.log('Usage: node scripts/setAdmin.js user@example.com');
  console.log('');
  console.log('Example:');
  console.log('  node scripts/setAdmin.js admin@petshop.com');
  process.exit(1);
}

// Validate email format
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test(email)) {
  console.error('❌ Invalid email format');
  process.exit(1);
}

setAdmin(email).then(() => {
  process.exit(0);
});

