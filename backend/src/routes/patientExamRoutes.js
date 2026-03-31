const express = require('express');
const router = express.Router();
const {
    createPatientExam,
    saveExamParameters
} = require('../controllers/patientExamController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.post('/', createPatientExam);
router.post('/:id/parameters', saveExamParameters);

module.exports = router;