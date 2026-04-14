const express = require('express');
const router = express.Router();
const patientExamController = require('../controllers/patientExamController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.post('/', patientExamController.createPatientExam);
router.post('/:id/parameters', patientExamController.saveExamParameters);
router.get('/', patientExamController.getPatientExamsByType);

module.exports = router;