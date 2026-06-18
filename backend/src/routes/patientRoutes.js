const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/search', patientController.searchPatients);
router.get('/', patientController.getAllPatients);
router.get('/:id', patientController.getPatientById);
router.post('/', patientController.createPatient);

module.exports = router;