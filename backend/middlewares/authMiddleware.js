// middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');
const config = require('config');
const User = require('../models/User');

const auth = async (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  try {
    const decoded = jwt.verify(token, config.get('jwtSecret'));
    console.log(decoded);
    const user = await User.findById(decoded.user.id).select('-password_hash');
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    req.user = user;
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid' });
  }
};

module.exports = auth;
