// controllers/userController.js
const User = require('../models/User');
const Follower = require('../models/Follower');

exports.getUserById = async (req, res, next) => {
  console.log('Fetching user by ID:', req.params.id);
  try {
    const user = await User.findById(req.params.id)
      .select('-password_hash')
      .populate('followers')  // Populate virtual field
      .populate('following'); // Populate virtual field

    if (!user) return res.status(404).json({ msg: 'User not found' });

    res.json(user);
  } catch (err) {
    next(err);
  }
};

exports.updateUser = async (req, res, next) => {
  const { name, email, birthdate, location } = req.body;

  try {
    const updatedFields = {
      name,
      email,
      birthdate,
      location: location
        ? {
            type: 'Point',
            coordinates: [location.longitude, location.latitude],
          }
        : undefined,
      updated_at: Date.now(),
    };

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { $set: updatedFields },
      { new: true }
    ).select('-password_hash');

    if (!user) return res.status(404).json({ msg: 'User not found' });

    res.json(user);
  } catch (err) {
    next(err);
  }
};

exports.getUsers = async (req, res, next) => {
  try {
    const users = await User.find().select('-password_hash');
    res.json(users);
  } catch (err) {
    next(err);
  }
};

exports.followUser = async (req, res, next) => {
  try {
    const follower_id = req.user.id;
    const following_id = req.params.id;

    if (follower_id === following_id) {
      return res.status(400).json({ msg: 'Cannot follow yourself' });
    }

    const existingFollow = await Follower.findOne({ follower_id, following_id });
    if (existingFollow) {
      return res.status(400).json({ msg: 'Already following this user' });
    }

    const follow = new Follower({ follower_id, following_id });
    await follow.save();

    res.json({ msg: 'Successfully followed the user' });
  } catch (err) {
    next(err);
  }
};

exports.unfollowUser = async (req, res, next) => {
  try {
    const follower_id = req.user.id;
    const following_id = req.params.id;

    const follow = await Follower.findOneAndDelete({ follower_id, following_id });
    if (!follow) {
      return res.status(400).json({ msg: 'Not following this user' });
    }

    res.json({ msg: 'Successfully unfollowed the user' });
  } catch (err) {
    next(err);
  }
};
