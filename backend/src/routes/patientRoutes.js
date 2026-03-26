const express = require('express');
const router = express.Router();
const {getAllPatients } = require('../controllers/patientController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.get('/', getAllPatients);

module.exports = router;