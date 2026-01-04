const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { authenticate } = require('../middleware/auth');
const { isAdmin } = require('../middleware/admin');

// Check admin status (no admin role required, just authentication)
router.get('/check', authenticate, adminController.checkAdmin);

// All other admin routes require authentication and admin role
router.use(authenticate);
router.use(isAdmin);

router.post('/set-admin', adminController.setAdmin);
router.post('/remove-admin', adminController.removeAdmin);
router.get('/admins', adminController.getAdmins);

module.exports = router;

