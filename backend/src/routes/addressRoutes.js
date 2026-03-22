const express = require('express');
const router = express.Router();
const { createAddress, getAddressById, updateAddress, deleteAddress } = require('../controllers/addressController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.post('/', createAddress);

module.exports = router;