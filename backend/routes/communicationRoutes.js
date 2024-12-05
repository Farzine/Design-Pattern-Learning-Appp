// routes/communicationRoutes.js
const express = require('express');
const router = express.Router();
const communicationController = require('../controllers/communicationController');
const auth = require('../middlewares/authMiddleware');
const { check, validationResult } = require('express-validator');

// @route   GET /api/messages/:userId
// @desc    Retrieve chat messages between users
// @access  Private
router.get('/messages/:userId', auth, communicationController.getMessages);

// @route   POST /api/messages
// @desc    Send a text message
// @access  Private
router.post(
  '/messages',
  auth,
  [
    check('receiver_id', 'Receiver ID is required').not().isEmpty(),
    check('content', 'Content is required').not().isEmpty(),
  ],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    communicationController.sendMessage(req, res, next);
  }
);

// @route   POST /api/audio-calls/initiate
// @desc    Initiate an audio call
// @access  Private
router.post(
  '/audio-calls/initiate',
  auth,
  [check('receiver_id', 'Receiver ID is required').not().isEmpty()],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    communicationController.initiateAudioCall(req, res, next);
  }
);

module.exports = router;
