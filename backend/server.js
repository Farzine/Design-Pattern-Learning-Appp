require('dotenv').config();
const express = require('express');
const connectDB = require('./config/db');

const errorHandler = require('./middlewares/errorHandler');
const rateLimiter = require('./middlewares/rateLimiter');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const designPatternRoutes = require('./routes/designPatternRoutes');
const practiceRoutes = require('./routes/practiceRoutes');
const socialRoutes = require('./routes/socialRoutes');
const communicationRoutes = require('./routes/communicationRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const progressRoutes = require('./routes/progressRoutes');


const app = express();

// Connect Database
connectDB();
const corsOptions ={
    origin:`*`, 
    methods:['GET','POST','PUT','DELETE'],
    credentials:true,            
    optionSuccessStatus:200,
  }

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
app.use('/api/progress', progressRoutes);

// Error Handler Middleware
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));


//https://documenter.getpostman.com/view/32714993/2sAYBbd8cG