// models/PracticeSession.js
const mongoose = require('mongoose');

const PracticeSessionSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  design_pattern_id: { type: mongoose.Schema.Types.ObjectId, ref: 'DesignPattern', required: true },
  questions: [
    {
      question: { type: String, required: true },
      options: {
        A: { type: String, required: true },
        B: { type: String, required: true },
        C: { type: String, required: true },
        D: { type: String, required: true },
      },
      correctAnswer: { type: String, enum: ['A', 'B', 'C', 'D'], required: true },
    },
  ],
  created_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('PracticeSession', PracticeSessionSchema);
