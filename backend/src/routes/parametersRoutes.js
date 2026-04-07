const express = require('express');
const router = express.Router();
const {
    getParameters,
    getParametersWithValuesByExamId,
    getPrimaryExamId,
    getDailyExamList,
    getExamDateTime,

    getExamTypeByExamId
} = require('../controllers/parametersController');
const { authenticateToken } = require('../middleware/auth');

router.get('/', authenticateToken, getParameters);
router.get('/values-by-exam-id', authenticateToken, getParametersWithValuesByExamId);
router.get('/primary-exam', authenticateToken, getPrimaryExamId);
router.get('/daily-exam-list', authenticateToken, getDailyExamList);
router.get('/exam-datetime', authenticateToken, getExamDateTime);
router.get('/exam-type', authenticateToken, getExamTypeByExamId);


module.exports = router;