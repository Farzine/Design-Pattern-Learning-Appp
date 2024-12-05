// models/Post.js
const mongoose = require('mongoose');

const PostSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  content: { type: String, required: true },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

// Virtual for likes
PostSchema.virtual('likes', {
  ref: 'Like',
  localField: '_id',
  foreignField: 'post_id',
  justOne: false,
});

// Virtual for comments
PostSchema.virtual('comments', {
  ref: 'Comment',
  localField: '_id',
  foreignField: 'post_id',
  justOne: false,
});

// Ensure virtuals are included when converting to JSON
PostSchema.set('toJSON', { virtuals: true });

module.exports = mongoose.model('Post', PostSchema);
