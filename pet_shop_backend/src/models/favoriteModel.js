const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');

const getFavoritesWithPetsByUserId = async (userId) => {
  const db = getFirestore();
  const snapshot = await db.collection('favorites').where('userId', '==', userId).get();

  const favoritesWithPets = await Promise.all(
    snapshot.docs.map(async (doc) => {
      const favoriteData = doc.data();
      const petDoc = await db.collection('pets').doc(favoriteData.petId).get();

      if (!petDoc.exists) {
        return {
          id: doc.id,
          ...convertTimestamps(favoriteData),
          pet: null,
        };
      }

      return {
        id: doc.id,
        ...convertTimestamps(favoriteData),
        pet: {
          id: petDoc.id,
          ...convertTimestamps(petDoc.data()),
        },
      };
    })
  );

  return favoritesWithPets;
};

const addFavoriteForUser = async (userId, petId) => {
  const db = getFirestore();

  const petDoc = await db.collection('pets').doc(petId).get();
  if (!petDoc.exists) {
    return { error: 'PET_NOT_FOUND' };
  }

  const existingSnapshot = await db
    .collection('favorites')
    .where('userId', '==', userId)
    .where('petId', '==', petId)
    .get();

  if (!existingSnapshot.empty) {
    return { error: 'ALREADY_FAVORITE' };
  }

  const favoriteData = {
    userId,
    petId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  const docRef = await db.collection('favorites').add(favoriteData);
  const newFavorite = await docRef.get();
  const favoriteResponseData = newFavorite.data();

  const petDetails = await db.collection('pets').doc(petId).get();
  const petResponseData = petDetails.exists ? petDetails.data() : null;

  return {
    id: newFavorite.id,
    ...convertTimestamps(favoriteResponseData),
    pet: petResponseData
      ? {
          id: petDetails.id,
          ...convertTimestamps(petResponseData),
        }
      : null,
  };
};

const removeFavoriteByIdForUser = async (favoriteId, userId) => {
  const db = getFirestore();
  const favoriteRef = db.collection('favorites').doc(favoriteId);

  const favoriteDoc = await favoriteRef.get();
  if (!favoriteDoc.exists) {
    return { error: 'FAVORITE_NOT_FOUND' };
  }

  if (favoriteDoc.data().userId !== userId) {
    return { error: 'FORBIDDEN' };
  }

  await favoriteRef.delete();
  return { success: true };
};

module.exports = {
  getFavoritesWithPetsByUserId,
  addFavoriteForUser,
  removeFavoriteByIdForUser,
};

