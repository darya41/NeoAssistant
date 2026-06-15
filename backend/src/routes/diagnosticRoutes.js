const express = require('express');
const router = express.Router();
const diagnosticController = require('../controllers/diagnosticController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.get('/', diagnosticController.getAllDiagnostics);
router.get('/search', diagnosticController.searchDiagnostics);

module.exports = router;