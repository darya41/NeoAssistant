const express = require('express');
const router = express.Router();
const examTypeController = require('../controllers/examTypeController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);
router.get('/type', examTypeController.getExamTypeByExamId);
router.get('/primary', examTypeController.getPrimaryExamId);
router.get('/daily-list', examTypeController.getDailyExamList);
router.get('/datetime', examTypeController.getExamDateTime);

module.exports = router;