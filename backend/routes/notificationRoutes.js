// routes/notificationRoutes.js
const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const auth = require('../middlewares/authMiddleware');
const { check, validationResult } = require('express-validator');

// @route   GET /api/notifications
// @desc    Get user’s notifications
// @access  Private
router.get('/', auth, notificationController.getNotifications);

// @route   POST /api/notifications/mark-as-read
// @desc    Mark notifications as read
// @access  Private
router.post(
  '/mark-as-read',
  auth,
  [check('notification_ids', 'notification_ids is required').isArray()],
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    notificationController.markAsRead(req, res, next);
  }
);

module.exports = router;
