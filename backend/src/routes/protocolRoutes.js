const express = require('express');
const router = express.Router();
const protocolController = require('../controllers/protocolController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.get('/list', protocolController.getProtocolListPaginated);
router.get('/search', protocolController.searchProtocols);
router.get('/:id/hierarchy', protocolController.getProtocolHierarchy);
router.get('/:id', protocolController.getProtocolDocumentById);
router.get('/hierarchy/:id/branch', protocolController.getFullBranch);
router.get('/medication/:medicationId', protocolController.getProtocolsByMedicationId);


module.exports = router;