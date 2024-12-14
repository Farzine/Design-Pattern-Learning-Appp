// controllers/authController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const config = require('config');
const User = require('../models/User');

exports.register = async (req, res, next) => {
  console.log('Register request data:', req.body); // Debugging

  const { name, email, password, birthdate, location } = req.body;

  try {
    // Validate location as GeoJSON Point
    if (
      !location ||
      location.type !== 'Point' ||
      !Array.isArray(location.coordinates) ||
      location.coordinates.length !== 2 ||
      typeof location.coordinates[0] !== 'number' ||
      typeof location.coordinates[1] !== 'number'
    ) {
      return res.status(400).json({ message: 'Invalid location data' });
    }

    const [longitude, latitude] = location.coordinates;

    // Check if user already exists
    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(password, salt);

    // Create new user with default points
    user = new User({
      name,
      email,
      password_hash,
      birthdate,
      location: {
        type: 'Point',
        coordinates: [longitude, latitude],
      },
      points: 0, // Initialize points
    });

    await user.save();

    // Create JWT payload
    const payload = {
      user: {
        id: user.id,
      },
    };

    // Sign JWT and respond
    jwt.sign(payload, config.get('jwtSecret'), { expiresIn: '3h' }, (err, token) => {
      if (err) throw err;
      res.json({ token, user });
    });
  } catch (err) {
    next(err);
  }
};



exports.login = async (req, res, next) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const payload = {
      user: {
        id: user.id,
      },
    };

    jwt.sign(payload, config.get('jwtSecret'), { expiresIn: '2h' }, (err, token) => {
      if (err) throw err;
      res.json({ token, user });
    });
  } catch (err) {
    next(err);
  }
};

exports.logout = async (req, res, next) => {
  // JWT is stateless; to "logout" you might implement token blacklisting
  // For simplicity, we'll just respond with success
  res.json({ msg: 'Logged out successfully' });
};
