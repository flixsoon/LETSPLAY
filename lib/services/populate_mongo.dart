import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  // Connect to the MongoDB database
  var db = await Db.create('mongodb://localhost:27017/letsplay');
  await db.open();
  print('Connected to the database');

  // Get the fields collection
  var fieldsCollection = db.collection('fields');

  // Static data for fields
  var fields = [
    {
      'title': 'Terrain A',
      'location': 'Maroc, Rabat',
      'price': '200 MAD',
      'imageUrl': 'https://example.com/terrain_a.jpg',
      'rating': 4.5,
      'reviews': 10
    },
    {
      'title': 'Terrain B',
      'location': 'Maroc, Salé',
      'price': '150 MAD',
      'imageUrl': 'https://example.com/terrain_b.jpg',
      'rating': 4.0,
      'reviews': 8
    },
    {
      'title': 'Terrain C',
      'location': 'Maroc, Témara',
      'price': '180 MAD',
      'imageUrl': 'https://example.com/terrain_c.jpg',
      'rating': 4.8,
      'reviews': 15
    }
  ];

  // Insert static data into the fields collection
  await fieldsCollection.insertAll(fields);
  print('Static data inserted into the fields collection');

  // Close the database connection
  await db.close();
  print('Database connection closed');
}
