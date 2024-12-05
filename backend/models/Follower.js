// models/Follower.js
const mongoose = require('mongoose');

const FollowerSchema = new mongoose.Schema({
  follower_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  following_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  created_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Follower', FollowerSchema);
