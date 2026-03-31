const express = require('express');
const router = express.Router();
const { getParameters, getAllParameters } = require('../controllers/parametersController');
const { authenticateToken } = require('../middleware/auth');

router.get('/', authenticateToken, getParameters);

module.exports = router;