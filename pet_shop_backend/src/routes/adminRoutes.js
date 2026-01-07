const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { authenticate } = require('../middleware/auth');

// Check admin status (no admin role required, just authentication)
// Admin is set manually via Firestore (users collection → isAdmin: true)
router.get('/check', authenticate, adminController.checkAdmin);

module.exports = router;

