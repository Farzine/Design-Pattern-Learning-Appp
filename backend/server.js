require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');
const config = require('config');
const bodyParser = require('body-parser');
const multer = require('multer');
const cors = require('cors'); 
const mongoose = require('mongoose');
const cookieParser = require('cookie-parser');


const errorHandler = require('./middlewares/errorHandler');
const rateLimiter = require('./middlewares/rateLimiter');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const designPatternRoutes = require('./routes/designPatternRoutes');
const practiceRoutes = require('./routes/practiceRoutes');
const socialRoutes = require('./routes/socialRoutes');
const communicationRoutes = require('./routes/communicationRoutes');
const notificationRoutes = require('./routes/notificationRoutes');

const app = express();

// Connect Database
connectDB();

// Init Middleware
app.use(express.json());
app.use(rateLimiter);

// Define Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/design-patterns', designPatternRoutes);
app.use('/api/design-patterns', practiceRoutes); // Nested routes
app.use('/api', socialRoutes);
app.use('/api', communicationRoutes);
app.use('/api/notifications', notificationRoutes);

// Error Handler Middleware
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));


//https://documenter.getpostman.com/view/32714993/2sAYBbd8cG