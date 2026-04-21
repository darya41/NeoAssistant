const express = require('express');
const router = express.Router();
const parametersController = require('../controllers/parametersController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/', parametersController.getParameters);
router.get('/values-by-exam-id', parametersController.getParametersWithValuesByExamId);

router.get('/with-values', parametersController.getParametersWithValues);
module.exports = router;