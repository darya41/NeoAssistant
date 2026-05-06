const express = require('express');
const router = express.Router();
const mkbController = require('../controllers/mkbController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.get('/level/:level', mkbController.getMkbByLevel);
router.get('/parent/:parentCode', mkbController.getMkbByParentCode);
router.get('/code/:code', mkbController.getMkbByCode);
router.get('/path/:code', mkbController.getMkbPath);
router.get('/search', mkbController.searchMkb);
router.get('/root', mkbController.getRootLevel);
router.get('/tree', mkbController.getTree);
router.get('/stats', mkbController.getStats);
router.get('/', mkbController.getAllMkb);
router.get('/:id', mkbController.getMkbById);

module.exports = router;