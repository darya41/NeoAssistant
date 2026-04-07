const express = require('express');
const router = express.Router();
const { createMother, getAllMothers, getMotherById } = require('../controllers/motherController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.post('/', createMother);
router.get('/', getAllMothers);
router.get('/:id', getMotherById);

module.exports = router;