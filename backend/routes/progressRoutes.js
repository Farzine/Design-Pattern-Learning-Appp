const express = require('express');
const progressController = require('../controllers/progressController');
const authMiddleware = require('../middlewares/authMiddleware');

const router = express.Router();

// Get progress for all design patterns for the authenticated user
router.get('/', authMiddleware, progressController.getUserProgress);

// Get progress for a specific design pattern
router.get('/:id', authMiddleware, progressController.getProgressByDesignPattern);

module.exports = router;
