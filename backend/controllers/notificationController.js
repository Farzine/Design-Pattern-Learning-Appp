// controllers/notificationController.js
const Notification = require('../models/Notification');

exports.getNotifications = async (req, res, next) => {
  try {
    const notifications = await Notification.find({ user_id: req.user.id }).sort({ created_at: -1 });
    res.json(notifications);
  } catch (err) {
    next(err);
  }
};

exports.markAsRead = async (req, res, next) => {
  try {
    const { notification_ids } = req.body;
    await Notification.updateMany(
      { _id: { $in: notification_ids }, user_id: req.user.id },
      { $set: { is_read: true } }
    );
    res.json({ msg: 'Notifications marked as read' });
  } catch (err) {
    next(err);
  }
};
