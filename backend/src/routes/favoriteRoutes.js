const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/FavoriteController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/check/:patientId', favoriteController.checkFavorite);
router.post('/', favoriteController.addFavorite);
router.delete('/:patientId', favoriteController.removeFavorite);

module.exports = router;