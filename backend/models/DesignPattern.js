// models/DesignPattern.js
const mongoose = require('mongoose');

const DesignPatternSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },
  video_url: { type: String },
  examples: { type: [mongoose.Schema.Types.Mixed] }, // Alternatively, use a separate collection
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('DesignPattern', DesignPatternSchema);
