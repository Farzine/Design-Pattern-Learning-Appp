// routes/practiceRoutes.js
const express = require('express');
const router = express.Router();
const practiceController = require('../controllers/practiceController');
const authMiddleware = require('../middlewares/authMiddleware');

// Get practice questions for a design pattern
router.get('/practice/:id', authMiddleware, practiceController.getPracticeQuestions);

// Submit answers for a practice session
router.post('/practice/:id/submit', authMiddleware, practiceController.submitAnswers);

module.exports = router;
