const express = require('express');
const router = express.Router();
const diagnosticController = require('../controllers/diagnosticController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.get('/', diagnosticController.getAllDiagnostics);
router.get('/all', diagnosticController.getAllDiagnosticsNoPagination);
router.get('/types', diagnosticController.getDiagnosticTypes);
router.get('/type/:type', diagnosticController.getDiagnosticsByType);
router.get('/search', diagnosticController.searchDiagnostics);
router.get('/:id', diagnosticController.getDiagnosticById);

module.exports = router;