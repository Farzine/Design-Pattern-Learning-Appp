//controllers/progressController.js
const UserProgress = require('../models/UserProgress');
const DesignPattern = require('../models/DesignPattern');
const mongoose = require('mongoose'); 

/**
 * Get user progress for all design patterns
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
exports.getUserProgress = async (req, res, next) => {
  try {
    const userId = req.user.id; // Assuming `req.user` contains the authenticated user ID

    // Fetch all progress entries for the user
    const progressEntries = await UserProgress.find({ user_id: userId })
      .populate('design_pattern_id', 'name') // Populate the name of the design pattern
      .sort({ updated_at: -1 }); // Sort by most recently updated

    if (!progressEntries.length) {
      return res.status(404).json({ msg: 'No progress found for the user' });
    }

    // Format the response for better UX
    const formattedProgress = progressEntries.map((entry) => ({
      designPattern: entry.design_pattern_id.name,
      progress: entry.progress, // Progress percentage
      points: entry.points,
      learningCompleted: entry.learning_completed,
      practiceCompleted: entry.practice_completed,
      testCompleted: entry.test_completed,
      updatedAt: entry.updated_at,
    }));

    res.json({ progress: formattedProgress });
  } catch (err) {
    console.error('Error fetching user progress:', err.message);
    next(err);
  }
};

/**
 * Get detailed progress for a specific design pattern
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
exports.getProgressByDesignPattern = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const designPatternId = req.params.id;

    // Validate the designPatternId
    if (!mongoose.Types.ObjectId.isValid(designPatternId)) {
      return res.status(400).json({ msg: 'Invalid Design Pattern ID' });
    }

    // Fetch the progress for the specific design pattern
    const progress = await UserProgress.findOne({
      user_id: userId,
      design_pattern_id: designPatternId,
    }).populate('design_pattern_id', 'name');

    if (!progress) {
      return res.status(404).json({ msg: 'No progress found for this design pattern' });
    }

    res.json({
      designPattern: progress.design_pattern_id.name,
      progress: progress.progress,
      points: progress.points,
      learningCompleted: progress.learning_completed,
      practiceCompleted: progress.practice_completed,
      testCompleted: progress.test_completed,
      updatedAt: progress.updated_at,
    });
  } catch (err) {
    console.error('Error fetching progress by design pattern:', err.message);
    next(err);
  }
};
