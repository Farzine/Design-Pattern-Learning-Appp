// models/User.js
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password_hash: { type: String, required: true },
  birthdate: { type: Date },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] },
  },
  profile_picture_url: { type: String },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

// Add virtual fields for followers and following
UserSchema.virtual('followers', {
  ref: 'Follower',
  localField: '_id',
  foreignField: 'following_id',
  justOne: false, // returns an array of followers
});

UserSchema.virtual('following', {
  ref: 'Follower',
  localField: '_id',
  foreignField: 'follower_id',
  justOne: false, // returns an array of users being followed
});


UserSchema.index({ location: '2dsphere' });

// Make sure to include virtual fields when serializing the user
UserSchema.set('toJSON', { virtuals: true });

module.exports = mongoose.model('User', UserSchema);
