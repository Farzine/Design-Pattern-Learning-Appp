// config/db.js
const mongoose = require('mongoose');
const config = require('config');

const connectDB = async () => {
  try {
    const dbURI = process.env.MONGO_URI || config.get('mongoURI');
    await mongoose.connect(dbURI); 
    console.log('MongoDB Connected');
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
};

module.exports = connectDB;
