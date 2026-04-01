const express = require('express');
const router = express.Router();
const {
    getParameters,
    getParametersWithValues,
    getPrimaryExamId
} = require('../controllers/parametersController');
const { authenticateToken } = require('../middleware/auth');

router.get('/', authenticateToken, getParameters);
router.get('/with-values', authenticateToken, getParametersWithValues);
router.get('/primary-exam', authenticateToken, getPrimaryExamId);

module.exports = router;