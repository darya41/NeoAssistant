const express = require('express');
const router = express.Router();
const motherController = require('../controllers/motherController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.post('/', motherController.createMother);
router.get('/', motherController.getAllMothers);
router.get('/:id', motherController.getMotherById);

module.exports = router;