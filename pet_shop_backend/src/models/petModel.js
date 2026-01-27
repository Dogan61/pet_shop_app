const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');
const { convertTimestamps } = require('../utils/firestoreHelper');

const getPets = async ({ category, page = 1, limit = 10 }) => {
  const db = getFirestore();

  let query = db.collection('pets');

  if (category && category !== 'all') {
    query = query.where('category', '==', category);
  }

  const countSnapshot = await query.get();
  const total = countSnapshot.size;

  const startIndex = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const snapshot = await query
    .orderBy('createdAt', 'desc')
    .limit(parseInt(limit, 10))
    .offset(startIndex)
    .get();

  const pets = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...convertTimestamps(doc.data()),
  }));

  return {
    pets,
    pagination: {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      total,
      pages: Math.ceil(total / parseInt(limit, 10)),
    },
  };
};

const getPetById = async (id) => {
  const db = getFirestore();
  const petDoc = await db.collection('pets').doc(id).get();

  if (!petDoc.exists) {
    return null;
  }

  return {
    id: petDoc.id,
    ...convertTimestamps(petDoc.data()),
  };
};

const getPetsByCategory = async (category) => {
  const db = getFirestore();
  const snapshot = await db.collection('pets').where('category', '==', category).get();

  const pets = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...convertTimestamps(doc.data()),
  }));

  return pets;
};

const createPet = async (data) => {
  const db = getFirestore();
  const petData = {
    ...data,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  const docRef = await db.collection('pets').add(petData);
  const newPet = await docRef.get();

  return {
    id: newPet.id,
    ...convertTimestamps(newPet.data()),
  };
};

const updatePet = async (id, data) => {
  const db = getFirestore();
  const petRef = db.collection('pets').doc(id);

  const petDoc = await petRef.get();
  if (!petDoc.exists) {
    return null;
  }

  await petRef.update({
    ...data,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const updatedPet = await petRef.get();

  return {
    id: updatedPet.id,
    ...convertTimestamps(updatedPet.data()),
  };
};

const deletePet = async (id) => {
  const db = getFirestore();
  const petRef = db.collection('pets').doc(id);

  const petDoc = await petRef.get();
  if (!petDoc.exists) {
    return false;
  }

  await petRef.delete();
  return true;
};

module.exports = {
  getPets,
  getPetById,
  getPetsByCategory,
  createPet,
  updatePet,
  deletePet,
};

