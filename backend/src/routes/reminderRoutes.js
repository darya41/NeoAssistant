const express = require('express');
const router = express.Router();
const reminderController = require('../controllers/reminderController');
const { authenticateToken } = require('../middleware/auth');
const { requireAuth } = require('../middleware/requireAuth');

router.use(authenticateToken);
router.use(requireAuth);

router.get('/stats', reminderController.getStats);
router.get('/', reminderController.getAll);
router.get('/:id', reminderController.getOne);
router.post('/', reminderController.create);
router.put('/:id', reminderController.update);
router.delete('/:id', reminderController.delete);

module.exports = router;