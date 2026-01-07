const admin = require('firebase-admin');

/**
 * Create default user profile data
 * @param {Object} options - User data options
 * @param {string} options.uid - User UID
 * @param {string} [options.email] - User email
 * @param {string} [options.fullName] - User full name
 * @param {string} [options.phone] - User phone
 * @param {string} [options.address] - User address
 * @param {string} [options.profileImage] - User profile image URL
 * @returns {Object} User profile data object
 */
const createUserProfileData = ({
  uid,
  email = '',
  fullName = '',
  phone = '',
  address = '',
  profileImage = '',
}) => ({
  uid,
  email,
  fullName,
  phone,
  address,
  profileImage,
  createdAt: admin.firestore.FieldValue.serverTimestamp(),
  updatedAt: admin.firestore.FieldValue.serverTimestamp(),
});

/**
 * Create or update user profile in Firestore
 * @param {Object} db - Firestore database instance
 * @param {string} uid - User UID
 * @param {Object} userData - User data to set/update
 * @returns {Promise<Object>} User document data
 */
const createOrUpdateUserProfile = async (db, uid, userData) => {
  const userRef = db.collection('users').doc(uid);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    await userRef.set(userData);
    return { id: uid, ...userData };
  }

  // Update if needed
  if (userData.profileImage && userDoc.data().profileImage !== userData.profileImage) {
    await userRef.update({
      profileImage: userData.profileImage,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  return { id: uid, ...userDoc.data() };
};

module.exports = {
  createUserProfileData,
  createOrUpdateUserProfile,
};

