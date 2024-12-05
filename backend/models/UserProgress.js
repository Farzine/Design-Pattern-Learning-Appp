// models/UserProgress.js
const mongoose = require('mongoose');

const UserProgressSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  design_pattern_id: { type: mongoose.Schema.Types.ObjectId, ref: 'DesignPattern', required: true },
  learning_completed: { type: Boolean, default: false },
  practice_completed: { type: Number, default: 0 }, // Number of correct answers
  test_completed: { type: Boolean, default: false },
  points: { type: Number, default: 0 },
  progress: { type: Number, default: 0 }, // Progress percentage
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('UserProgress', UserProgressSchema);
