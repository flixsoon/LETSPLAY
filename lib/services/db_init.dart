import 'package:mongo_dart/mongo_dart.dart';
import 'mongo_service.dart';

class DatabaseInitializer {
  static Future<void> initializeDatabase() async {
    try {
      // Create collections
      final db = MongoService.db!;
      
      // Create fields collection
      await db.createCollection('fields');
      
      // Create users collection
      await db.createCollection('users');
      
      // Create reservations collection
      await db.createCollection('reservations');
      
      // Insert sample fields data
      final fieldsCollection = db.collection('fields');
      await fieldsCollection.insertMany([
        {
          'title': 'Terrain Bettana',
          'location': 'Rabat-Salé',
          'price': '200DH/Heure',
          'rating': 4.55,
          'reviews': 93,
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
          'availableHours': List.generate(24, (index) => true),
          'amenities': ['Parking', 'Wifi', 'Showers'],
          'description': 'Professional football field with modern facilities'
        },
        {
          'title': 'Taqadum Football Club',
          'location': 'Rabat-Salé',
          'price': '200DH/Heure',
          'rating': 4.44,
          'reviews': 50,
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
          'availableHours': List.generate(24, (index) => true),
          'amenities': ['Parking', 'Cafeteria', 'Lockers'],
          'description': 'Popular football club with multiple fields'
        }
      ]);
      
      print('Database initialized successfully!');
    } catch (e) {
      print('Failed to initialize database: $e');
      rethrow;
    }
  }
} 