const express = require('express');
const router = express.Router();
const doctorController = require('../controllers/doctorController');
const { authenticateToken } = require('../middleware/auth');

router.put('/profile', authenticateToken, doctorController.updateProfile);

module.exports = router;