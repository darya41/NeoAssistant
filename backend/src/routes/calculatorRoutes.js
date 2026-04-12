const express = require('express');
const router = express.Router();
const calculatorController = require('../controllers/calculatorController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.get('/', calculatorController.getAllCalculators);
router.get('/search', calculatorController.searchCalculators);
router.get('/type/:type', calculatorController.getCalculatorsByType);
router.get('/:id', calculatorController.getCalculatorById);

module.exports = router;