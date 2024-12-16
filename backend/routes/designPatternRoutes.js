// routes/designPatternRoutes.js
const express = require('express');
const router = express.Router();
const designPatternController = require('../controllers/designPatternController');
const auth = require('../middlewares/authMiddleware');

// @route   GET /api/design-patterns
// @desc    Retrieve all design patterns
// @access  Private
router.get('/', auth, designPatternController.getAllDesignPatterns);

// @route   GET /api/design-patterns/:id
// @desc    Get detailed content for a specific design pattern
// @access  Private
router.get('/:id', auth, designPatternController.getDesignPatternById);

// Get all design patterns or search based on query
router.get('/search', auth, designPatternController.getDesignPatterns);

module.exports = router;
