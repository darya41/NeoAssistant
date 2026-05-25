const express = require('express');
const router = express.Router();
const medicationController = require('../controllers/medicationController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.get('/', medicationController.getAllMedications);
router.get('/class/:drugClass', medicationController.getMedicationsByDrugClass);
router.get('/search', medicationController.searchMedications);

module.exports = router;