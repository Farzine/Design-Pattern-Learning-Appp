// middlewares/rateLimiter.js
const rateLimit = require('express-rate-limit');
const config = require('config');

const limiter = rateLimit({
  windowMs: config.get('rateLimit.windowMs') * 60 * 1000, // e.g., 15 minutes
  max: config.get('rateLimit.max'), // limit each IP to max requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
});

module.exports = limiter;
