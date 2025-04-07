const mongoose = require('mongoose');

const reservationSchema = new mongoose.Schema({
  fieldId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Field',
    required: true
  },
  userId: {
    type: String,
    required: true
  },
  date: {
    type: Date,
    required: true
  },
  startTime: {
    type: String,
    required: true
  },
  duration: {
    type: Number,
    required: true
  },
  totalPrice: {
    type: Number,
    required: true
  },
  paymentMethod: {
    type: String,
    enum: ['cash', 'credit_card', 'paypal'],
    required: true
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed'],
    default: 'pending'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Reservation', reservationSchema); 