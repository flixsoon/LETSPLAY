const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Log all requests for debugging
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  console.log('Request headers:', req.headers);
  if (req.method !== 'GET') {
    console.log('Request body:', req.body);
  }
  next();
});

app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log('MongoDB Connection Error:', err));

// Test endpoint
app.get('/api/test', (req, res) => {
  console.log('Test endpoint accessed');
  res.json({ message: 'API is working!' });
});

// Routes
const fieldsRouter = require('./routes/fields');
const reservationsRouter = require('./routes/reservations');

app.use('/api/fields', fieldsRouter);
app.use('/api/reservations', reservationsRouter);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ message: 'Something went wrong on the server' });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 