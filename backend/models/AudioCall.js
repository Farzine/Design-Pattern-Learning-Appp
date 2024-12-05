// models/AudioCall.js
const mongoose = require('mongoose');

const AudioCallSchema = new mongoose.Schema({
  caller_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  receiver_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  call_start_time: { type: Date },
  call_end_time: { type: Date },
  status: { type: String, enum: ['initiated', 'completed', 'missed'], default: 'initiated' },
});

module.exports = mongoose.model('AudioCall', AudioCallSchema);
