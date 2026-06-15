const express = require('express');
const router = express.Router();
const techLevelController = require('../controllers/techLevelController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/', techLevelController.getAllTechLevels);
router.get('/my', techLevelController.getMyTechLevel);
router.put('/my', techLevelController.updateMyTechLevel);

module.exports = router;