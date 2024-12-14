// controllers/practiceController.js
const mongoose = require('mongoose');
const aiService = require('../services/aiService');
const UserProgress = require('../models/UserProgress');
const DesignPattern = require('../models/DesignPattern');
const PracticeSession = require('../models/PracticeSession');

exports.getPracticeQuestions = async (req, res, next) => {
  try {
    const designPatternId = req.params.id;
    const userId = req.user.id; // Assuming `req.user` is populated by authMiddleware

    // Validate the designPatternId
    if (!mongoose.Types.ObjectId.isValid(designPatternId)) {
      return res.status(400).json({ msg: 'Invalid Design Pattern ID' });
    }

    // Fetch the design pattern from the database
    const designPattern = await DesignPattern.findById(designPatternId);
    if (!designPattern) {
      return res.status(404).json({ msg: 'Design Pattern not found' });
    }

    // Use the design pattern's name to generate questions
    const questions = await aiService.generatePracticeQuestions(designPattern.name, userId, designPatternId);

    res.json({ questions });
  } catch (err) {
    next(err);
  }
};

exports.submitAnswers = async (req, res, next) => {
  try {
    const designPatternId = req.params.id;
    const userId = req.user.id;
    const { answers } = req.body;

    console.log('Answers:', answers);

    // Validate the designPatternId
    if (!mongoose.Types.ObjectId.isValid(designPatternId)) {
      return res.status(400).json({ msg: 'Invalid Design Pattern ID' });
    }

    // Fetch the design pattern from the database
    const designPattern = await DesignPattern.findById(designPatternId);
    if (!designPattern) {
      return res.status(404).json({ msg: 'Design Pattern not found' });
    }

    // Fetch the latest PracticeSession for the user and design pattern
    const practiceSession = await PracticeSession.findOne({ user_id: userId, design_pattern_id: designPatternId }).sort({ created_at: -1 });
    if (!practiceSession) {
      return res.status(404).json({ msg: 'No practice session found for this design pattern' });
    }

    const { questions } = practiceSession;

    // Validate the answers structure
    if (!Array.isArray(answers) || answers.length !== questions.length) {
      return res.status(400).json({ msg: `Expected ${questions.length} answers` });
    }

    let correctCount = 0;
    const feedback = [];

    // Iterate through each answer and evaluate correctness
    answers.forEach((userAnswer, index) => {
      const question = questions[index];
      const correctAnswer = question.correctAnswer.toUpperCase();

      // Check if the userAnswer is valid
      if (typeof userAnswer !== 'string' || !['A', 'B', 'C', 'D'].includes(userAnswer.toUpperCase())) {
        feedback.push({
          question: question.question,
          correct: false,
          message: 'Invalid or missing answer.',
        });
        return;
      }

      const userSelected = userAnswer.toUpperCase();

      if (userSelected === correctAnswer) {
        correctCount += 1;
        feedback.push({
          question: question.question,
          correct: true,
          message: 'Correct!',
        });
      } else {
        feedback.push({
          question: question.question,
          correct: false,
          message: `Incorrect. The correct answer was ${correctAnswer}.`,
        });
      }
    });

    // Calculate progress increment
    const progressIncrement = (correctCount / questions.length) * 100;

    // Update UserProgress
    let progress = await UserProgress.findOne({ user_id: userId, design_pattern_id: designPatternId });
    if (!progress) {
      progress = new UserProgress({
        user_id: userId,
        design_pattern_id: designPatternId,
        practice_completed: 0,
        points: 0,
        progress: 0,
        learning_completed: false,
      });
    }

    progress.practice_completed += correctCount;
    progress.points += correctCount * 10; // Example points: 10 points per correct answer
    progress.progress = Math.min(progress.progress + progressIncrement, 100);

    // If all questions are answered correctly, set learning_completed to true
    if (progress.progress === 100) {
      progress.learning_completed = true;
    }

    // Update the timestamp
    progress.updated_at = Date.now();

    await progress.save();

    res.json({
      feedback,
      correctCount,
      totalQuestions: questions.length,
      progress: progress.progress,
    });
  } catch (err) {
    console.error('Error in submitAnswers:', err.message);
    next(err);
  }
};

