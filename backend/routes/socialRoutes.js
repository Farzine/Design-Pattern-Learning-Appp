// routes/socialRoutes.js
const express = require('express');
const router = express.Router();
const socialController = require('../controllers/socialController');
const auth = require('../middlewares/authMiddleware');
const { check, validationResult } = require('express-validator');

// @route   POST /api/posts
// @desc    Create a new post
// @access  Private
router.post(
  '/posts',
  auth,
  [check('content', 'Content is required').not().isEmpty()],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    socialController.createPost(req, res, next);
  }
);

// @route   GET /api/posts/feed
// @desc    Get feed of posts from followed users
// @access  Private
router.get('/posts/feed', auth, socialController.getFeed);

// @route   POST /api/posts/:id/like
// @desc    Like a post
// @access  Private
router.post('/posts/:id/like', auth, socialController.likePost);

// @route   POST /api/posts/:id/comment
// @desc    Comment on a post
// @access  Private
router.post(
  '/posts/:id/comment',
  auth,
  [check('content', 'Content is required').not().isEmpty()],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    socialController.commentOnPost(req, res, next);
  }
);

module.exports = router;
