// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middlewares/authMiddleware');
const { check, validationResult } = require('express-validator');


// GET /api/users/me - returns the current user
router.get('/me', auth, (req, res) => {
  if (!req.user) {
    return res.status(404).json({ msg: 'User not found' });
  }
  res.json(req.user); // req.user is set by auth middleware
});

// @route   GET /api/users/:id
// @desc    Get user profile by ID
// @access  Private
router.get('/:id', auth, userController.getUserById);

// @route   PUT /api/users/:id
// @desc    Update user profile
// @access  Private
router.put(
  '/:id',
  auth,
  [
    check('email', 'Please include a valid email').optional().isEmail(),
    // Add more validations as needed
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    userController.updateUser(req, res, next);
  }
);

// @route   GET /api/users
// @desc    Get list of users
// @access  Private
router.get('/', auth, userController.getUsers);



// @route   POST /api/users/:id/follow
// @desc    Follow a user
// @access  Private
router.post('/:id/follow', auth, userController.followUser);

// @route   POST /api/users/:id/unfollow
// @desc    Unfollow a user
// @access  Private
router.post('/:id/unfollow', auth, userController.unfollowUser);

// Route for fetching followers of a user
router.get('/:id/followers', auth, userController.getUserFollowers);

// @route   GET /api/users
// @desc    Get all users (exclude current user if desired)
// @access  Private
router.get('/users', auth, userController.getAllUsers);

module.exports = router;
