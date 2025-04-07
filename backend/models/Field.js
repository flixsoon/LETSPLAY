const mongoose = require('mongoose');

const fieldSchema = new mongoose.Schema({
  title: String,
  location: String,
  price: String,
  rating: Number,
  reviews: Number,
  imageUrl: String,
  availableHours: [Boolean],
  amenities: [String],
  description: String
});

module.exports = mongoose.model('Field', fieldSchema); 