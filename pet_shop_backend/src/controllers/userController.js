const { getFirestore } = require('../config/firebase');
const admin = require('firebase-admin');

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
exports.getProfile = async (req, res, next) => {
  try {
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(req.user.uid).get();
    
    if (!userDoc.exists) {
      // Create user profile if doesn't exist
      const userData = {
        uid: req.user.uid,
        email: req.user.email || '',
        fullName: req.user.displayName || '',
        phone: '',
        address: '',
        profileImage: req.user.photoURL || '',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      
      await db.collection('users').doc(req.user.uid).set(userData);
      
      return res.json({
        success: true,
        data: {
          id: req.user.uid,
          ...userData,
        },
      });
    }
    
    res.json({
      success: true,
      data: {
        id: userDoc.id,
        ...userDoc.data(),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
exports.updateProfile = async (req, res, next) => {
  try {
    const db = getFirestore();
    const userRef = db.collection('users').doc(req.user.uid);
    
    const updateData = {
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    await userRef.update(updateData);
    
    const updatedUser = await userRef.get();
    
    res.json({
      success: true,
      data: {
        id: updatedUser.id,
        ...updatedUser.data(),
      },
    });
  } catch (error) {
    next(error);
  }
};


