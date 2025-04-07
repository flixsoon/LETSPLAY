import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<List<Map<String, dynamic>>> getFields() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fields'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load fields');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  static Future<Map<String, dynamic>> createField(Map<String, dynamic> field) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/fields'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(field),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create field');
      }
    } catch (e) {
      print('Error creating field: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createReservation(Map<String, dynamic> reservationData) async {
    try {
      print('Sending reservation data: ${json.encode(reservationData)}');

      // First, test if the API is accessible
      try {
        final testResponse = await http.get(Uri.parse('$baseUrl/test'));
        print('API test response: ${testResponse.statusCode} - ${testResponse.body}');
      } catch (e) {
        print('API test failed: $e');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/reservations'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reservationData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Reservation endpoint not found. Please check server configuration.');
      } else {
        String errorMessage = 'Failed to create reservation';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody['message'] != null) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          // If we can't parse the JSON, use the response body directly
          errorMessage = 'Failed to create reservation: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error in createReservation: $e');
      throw Exception('Error connecting to server: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getFieldReservations(String fieldId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reservations/field/$fieldId'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserReservations(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reservations/user/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load user reservations');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  static Future<Map<String, dynamic>> updatePaymentStatus(String reservationId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/reservations/$reservationId/payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'paymentStatus': status}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update payment status');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
} 