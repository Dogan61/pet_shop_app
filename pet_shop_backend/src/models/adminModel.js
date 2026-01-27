const { getFirestore } = require('../config/firebase');

const getAdminStatusForUser = async (uid) => {
  const db = getFirestore();
  const userDoc = await db.collection('users').doc(uid).get();

  let isAdminFromFirestore = false;
  if (userDoc.exists) {
    const userData = userDoc.data();
    isAdminFromFirestore = userData.isAdmin === true;
  }

  return {
    uid,
    isAdmin: isAdminFromFirestore,
  };
};

module.exports = {
  getAdminStatusForUser,
};

