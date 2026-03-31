const express = require('express');
const router = express.Router();
const {
    getAllPatients,
    getPatientById,
    createPatient
    } = require('../controllers/patientController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.get('/', getAllPatients);
router.get('/:id', getPatientById);
router.post('/', createPatient);

module.exports = router;