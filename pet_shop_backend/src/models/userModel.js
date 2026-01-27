const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { createUserProfileData, createOrUpdateUserProfile } = require('../utils/userHelper');

const getUserById = async (uid) => {
  const db = getFirestore();
  const userDoc = await db.collection('users').doc(uid).get();
  if (!userDoc.exists) {
    return null;
  }

  return { id: userDoc.id, ...userDoc.data() };
};

const createUserProfile = async (uid, data) => {
  const db = getFirestore();
  const userData = {
    ...data,
    createdAt: data.createdAt || admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: data.updatedAt || admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection('users').doc(uid).set(userData);
  return { id: uid, ...userData };
};

const updateUserProfile = async (uid, data) => {
  const db = getFirestore();
  const userRef = db.collection('users').doc(uid);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    return null;
  }

  const updateData = {
    ...data,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await userRef.update(updateData);
  const updatedUser = await userRef.get();

  return { id: updatedUser.id, ...updatedUser.data() };
};

const getOrCreateUserByDecodedToken = async (decodedToken, fallbackEmail) => {
  const db = getFirestore();
  const userDoc = await db.collection('users').doc(decodedToken.uid).get();

  if (userDoc.exists) {
    return { id: userDoc.id, ...userDoc.data() };
  }

  const userData = createUserProfileData({
    uid: decodedToken.uid,
    email: decodedToken.email || fallbackEmail || '',
    fullName: decodedToken.name || '',
    profileImage: decodedToken.picture || '',
  });

  await db.collection('users').doc(decodedToken.uid).set(userData);
  return { id: decodedToken.uid, ...userData };
};

const getOrCreateUserFromRecordOrDecoded = async (auth, decodedToken, fallbackEmail) => {
  const db = getFirestore();
  const userDoc = await db.collection('users').doc(decodedToken.uid).get();

  if (userDoc.exists) {
    return { id: userDoc.id, ...userDoc.data() };
  }

  let userRecord = null;
  try {
    userRecord = await auth.getUser(decodedToken.uid);
  } catch (err) {
    // ignore, we will use decoded token data
  }

  const userData = createUserProfileData({
    uid: decodedToken.uid,
    email: decodedToken.email || fallbackEmail || userRecord?.email || '',
    fullName: decodedToken.name || userRecord?.displayName || '',
    profileImage: decodedToken.picture || userRecord?.photoURL || '',
  });

  await db.collection('users').doc(decodedToken.uid).set(userData);
  return { id: decodedToken.uid, ...userData };
};

const createOrUpdateSocialUserProfile = async (uid, rawData) => {
  const db = getFirestore();
  const userData = createUserProfileData(rawData);
  const userProfile = await createOrUpdateUserProfile(db, uid, userData);
  return userProfile;
};

module.exports = {
  getUserById,
  createUserProfile,
  updateUserProfile,
  getOrCreateUserByDecodedToken,
  getOrCreateUserFromRecordOrDecoded,
  createOrUpdateSocialUserProfile,
};


