const express = require('express');
const router = express.Router();
const protocolController = require('../controllers/protocolController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/documents', protocolController.getAllProtocolDocuments);
router.get('/:id/hierarchy', protocolController.getProtocolHierarchy);
router.get('/:id', protocolController.getProtocolDocumentById);
router.get('/hierarchy/:id/branch', protocolController.getFullBranch);

module.exports = router;