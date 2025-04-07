const express = require('express');
const router = express.Router();
const Reservation = require('../models/Reservation');
const Field = require('../models/Field');

// Create a new reservation
router.post('/', async (req, res) => {
  try {
    console.log('Received reservation request:', req.body);

    const {
      fieldId,
      userId,
      date,
      startTime,
      duration,
      totalPrice,
      paymentMethod
    } = req.body;

    // Validate required fields
    if (!fieldId || !userId || !date || !startTime || !duration || totalPrice === undefined || !paymentMethod) {
      console.log('Missing required fields:', { fieldId, userId, date, startTime, duration, totalPrice, paymentMethod });
      return res.status(400).json({ message: 'All fields are required' });
    }

    // Validate field exists
    try {
      const field = await Field.findById(fieldId);
      if (!field) {
        console.log('Field not found with ID:', fieldId);
        return res.status(404).json({ message: 'Field not found' });
      }
    } catch (error) {
      console.log('Error finding field:', error);
      return res.status(400).json({ message: 'Invalid field ID format' });
    }

    // Parse date properly
    let reservationDate;
    try {
      reservationDate = new Date(date);
      if (isNaN(reservationDate.getTime())) {
        throw new Error('Invalid date format');
      }
    } catch (error) {
      console.log('Date parsing error:', error);
      return res.status(400).json({ message: 'Invalid date format. Use YYYY-MM-DD' });
    }

    // Check if the time slot is available
    const existingReservation = await Reservation.findOne({
      fieldId,
      date: reservationDate,
      startTime,
      paymentStatus: { $ne: 'failed' }
    });

    if (existingReservation) {
      return res.status(400).json({ message: 'Time slot is already booked' });
    }

    const reservation = new Reservation({
      fieldId,
      userId,
      date: reservationDate,
      startTime,
      duration,
      totalPrice,
      paymentMethod
    });

    const savedReservation = await reservation.save();
    console.log('Reservation created successfully:', savedReservation);
    res.status(201).json(savedReservation);
  } catch (error) {
    console.error('Error creating reservation:', error);
    res.status(500).json({ message: error.message });
  }
});

// Get reservations for a specific field
router.get('/field/:fieldId', async (req, res) => {
  try {
    const reservations = await Reservation.find({
      fieldId: req.params.fieldId,
      paymentStatus: { $ne: 'failed' }
    });
    res.json(reservations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get reservations for a specific user
router.get('/user/:userId', async (req, res) => {
  try {
    const reservations = await Reservation.find({
      userId: req.params.userId
    }).populate('fieldId');
    res.json(reservations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update payment status
router.patch('/:id/payment', async (req, res) => {
  try {
    const { paymentStatus } = req.body;
    const reservation = await Reservation.findByIdAndUpdate(
      req.params.id,
      { paymentStatus },
      { new: true }
    );
    if (!reservation) {
      return res.status(404).json({ message: 'Reservation not found' });
    }
    res.json(reservation);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 