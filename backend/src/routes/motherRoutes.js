const express = require('express');
const router = express.Router();
const { createMother, getAllMothers, getMotherById, updateMother, deleteMother } = require('../controllers/motherController');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

router.post('/', createMother);

module.exports = router;