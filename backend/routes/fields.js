const express = require('express');
const router = express.Router();
const Field = require('../models/Field');

// Get all fields
router.get('/', async (req, res) => {
  try {
    console.log('Getting all fields');
    const fields = await Field.find();
    res.json(fields);
  } catch (error) {
    console.error('Error getting fields:', error);
    res.status(500).json({ message: error.message });
  }
});

// Get a specific field
router.get('/:id', async (req, res) => {
  try {
    const field = await Field.findById(req.params.id);
    if (!field) {
      return res.status(404).json({ message: 'Field not found' });
    }
    res.json(field);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create a new field
router.post('/', async (req, res) => {
  try {
    const field = new Field(req.body);
    const savedField = await field.save();
    res.status(201).json(savedField);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 