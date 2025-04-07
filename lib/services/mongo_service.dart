import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static Db? _db;
  static bool _isConnected = false;
  
  // MongoDB connection configuration
  static const String _defaultConnectionString = 'mongodb://localhost:27017/letsplay';
  static String _connectionString = _defaultConnectionString;

  // Getter for the database instance
  static Db? get db => _db;

  // Set the connection string
  static void setConnectionString(String connectionString) {
    _connectionString = connectionString;
  }

  // Initialize the connection
  static Future<void> connect() async {
    try {
      _db = Db(_connectionString);
      await _db!.open();
      _isConnected = true;
      print('MongoDB connected successfully to $_connectionString');
    } catch (e) {
      _isConnected = false;
      print('Failed to connect to MongoDB: $e');
      rethrow;
    }
  }

  static bool get isConnected => _isConnected;

  // Disconnect from the database
  static Future<void> disconnect() async {
    if (_isConnected) {
      await _db!.close();
      _isConnected = false;
      print('Disconnected from MongoDB');
    }
  }

  // Ensure the database is connected
  static void _ensureConnected() {
    if (!_isConnected) {
      throw Exception(
          'Database is not connected. Call MongoService.connect() first.');
    }
  }

  // Fetch data from a collection
  static Future<List<Map<String, dynamic>>> fetchCollection(
      String collectionName) async {
    _ensureConnected();
    try {
      final collection = _db!.collection(collectionName);
      return await collection.find().toList();
    } catch (e) {
      print('Failed to fetch data from $collectionName: $e');
      rethrow;
    }
  }

  // Insert data into a collection
  static Future<void> insertDocument(
      String collectionName, Map<String, dynamic> document) async {
    _ensureConnected();
    try {
      final collection = _db!.collection(collectionName);
      await collection.insertOne(document);
      print('Document inserted into $collectionName');
    } catch (e) {
      print('Failed to insert document into $collectionName: $e');
      rethrow;
    }
  }

  // Update a document
  static Future<void> updateDocument(String collectionName,
      Map<String, dynamic> query, Map<String, dynamic> update) async {
    _ensureConnected();
    try {
      final collection = _db!.collection(collectionName);
      final updates = update.entries
          .map((entry) => modify.set(entry.key, entry.value))
          .toList();
      await collection.updateOne(query, updates);
      print('Document updated in $collectionName');
    } catch (e) {
      print('Failed to update document in $collectionName: $e');
      rethrow;
    }
  }

  // Delete a document
  static Future<void> deleteDocument(
      String collectionName, Map<String, dynamic> query) async {
    _ensureConnected();
    try {
      final collection = _db!.collection(collectionName);
      await collection.deleteOne(query);
      print('Document deleted from $collectionName');
    } catch (e) {
      print('Failed to delete document from $collectionName: $e');
      rethrow;
    }
  }

  // Fetch fields by location
  static Future<List<Map<String, dynamic>>> fetchFields(String location) async {
    if (!_isConnected) {
      throw Exception(
          'Database is not connected. Call MongoService.connect() first.');
    }
    final collection =
        _db!.collection('fields'); // Replace with your collection name
    return await collection.find({'location': location}).toList();
  }
}
