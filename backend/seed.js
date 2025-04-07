const mongoose = require('mongoose');
const Field = require('./models/Field');
const Reservation = require('./models/Reservation');
require('dotenv').config();

async function seedDatabase() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB for seeding');

    // Clear existing data
    await Field.deleteMany({});
    await Reservation.deleteMany({});
    console.log('Cleared existing data');

    // Create sample fields
    const fields = await Field.create([
      {
        title: 'Terrain Bettana',
        location: 'Rabat-Salé',
        price: '200DH/Heure',
        rating: 4.5,
        reviews: 93,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
        availableHours: Array(24).fill(true),
        amenities: ['Parking', 'Wifi', 'Showers'],
        description: 'Professional football field with modern facilities'
      },
      {
        title: 'Marina Football Club',
        location: 'Maroc, Salé',
        price: '280DH/Heure',
        rating: 4.8,
        reviews: 150,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
        availableHours: Array(24).fill(true),
        amenities: ['Parking', 'Cafeteria', 'Lockers', 'VIP Lounge'],
        description: 'Premium football facility with VIP amenities'
      }
    ]);

    console.log('Sample fields created');

    // Create sample reservations
    const sampleReservation = {
      fieldId: fields[0]._id, // Using the first field's ID
      userId: 'temp_user_id',
      date: new Date('2025-04-10'),
      startTime: '15:00',
      duration: 2,
      totalPrice: 400,
      paymentMethod: 'cash',
      paymentStatus: 'pending'
    };

    await Reservation.create(sampleReservation);
    console.log('Sample reservation created');

    console.log('Database seeded successfully');
  } catch (error) {
    console.error('Error seeding database:', error);
  } finally {
    await mongoose.connection.close();
    console.log('Database connection closed');
  }
}

seedDatabase(); 