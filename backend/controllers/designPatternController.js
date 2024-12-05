// controllers/designPatternController.js
const mongoose = require('mongoose');  // Add this line
const DesignPattern = require('../models/DesignPattern');

exports.getAllDesignPatterns = async (req, res, next) => {
  try {
    const patterns = await DesignPattern.find();
    res.json(patterns);
  } catch (err) {
    next(err);
  }
};

exports.getDesignPatternById = async (req, res, next) => {
  const { id } = req.params;

  // Check if the provided ID is a valid MongoDB ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ msg: 'Invalid Design Pattern ID' });
  }

  try {
    const pattern = await DesignPattern.findById(id);
    if (!pattern) {
      return res.status(404).json({ msg: 'Design Pattern not found' });
    }
    res.json(pattern);
  } catch (err) {
    next(err);
  }
};
