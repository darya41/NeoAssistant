const express = require('express');
const router = express.Router();
const {
    getParameters,
    getParametersWithValuesByExamId,
} = require('../controllers/parametersController');
const { authenticateToken } = require('../middleware/auth');

router.get('/', authenticateToken, getParameters);
router.get('/values-by-exam-id', authenticateToken, getParametersWithValuesByExamId);


module.exports = router;