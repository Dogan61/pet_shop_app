const express = require('express');
const router = express.Router();
const petController = require('../controllers/petController');
const { authenticate } = require('../middleware/auth');
const { isAdmin } = require('../middleware/admin');

// Public routes
router.get('/', petController.getAllPets);
router.get('/:id', petController.getPetById);
router.get('/category/:category', petController.getPetsByCategory);

// Protected routes (admin only)
router.post('/', authenticate, isAdmin, petController.createPet);
router.put('/:id', authenticate, isAdmin, petController.updatePet);
router.delete('/:id', authenticate, isAdmin, petController.deletePet);

module.exports = router;


