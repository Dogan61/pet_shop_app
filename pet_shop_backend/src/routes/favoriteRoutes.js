const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/favoriteController');
const { authenticate } = require('../middleware/auth');

// All favorite routes require authentication
router.use(authenticate);

router.get('/', favoriteController.getFavorites);
router.post('/', favoriteController.addFavorite);
router.delete('/:id', favoriteController.removeFavorite);

module.exports = router;


