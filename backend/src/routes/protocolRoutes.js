const express = require('express');
const router = express.Router();
const protocolController = require('../controllers/protocolController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.get('/', protocolController.getAllProtocols);

module.exports = router;