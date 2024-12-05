// controllers/communicationController.js
const Message = require('../models/Message');
const AudioCall = require('../models/AudioCall');

exports.getMessages = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const otherUserId = req.params.userId;
    const messages = await Message.find({
      $or: [
        { sender_id: userId, receiver_id: otherUserId },
        { sender_id: otherUserId, receiver_id: userId },
      ],
    }).sort({ created_at: 1 });
    res.json(messages);
  } catch (err) {
    next(err);
  }
};

exports.sendMessage = async (req, res, next) => {
  try {
    const { receiver_id, content } = req.body;
    const message = new Message({ sender_id: req.user.id, receiver_id, content });
    await message.save();
    res.json(message);
  } catch (err) {
    next(err);
  }
};

exports.initiateAudioCall = async (req, res, next) => {
  try {
    const { receiver_id } = req.body;
    const call = new AudioCall({ caller_id: req.user.id, receiver_id, status: 'initiated' });
    await call.save();
    res.json(call);
  } catch (err) {
    next(err);
  }
};
