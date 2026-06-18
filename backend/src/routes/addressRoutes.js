const express = require('express');
const router = express.Router();
const addressController =  require('../controllers/addressController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.post('/', addressController.createAddress);

module.exports = router;