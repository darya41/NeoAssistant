const express = require('express');
const router = express.Router();
const doctorController = require('../controllers/doctorController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.put('/profile', doctorController.updateProfile);

module.exports = router;