import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'PaymentPage.dart';

class ReserverPage extends StatefulWidget {
  final String fieldTitle;
  final String fieldLocation;
  final String fieldPrice;
  final String fieldId;

  const ReserverPage({
    Key? key,
    required this.fieldTitle,
    required this.fieldLocation,
    required this.fieldPrice,
    required this.fieldId,
  }) : super(key: key);

  @override
  _ReserverPageState createState() => _ReserverPageState();
}

class _ReserverPageState extends State<ReserverPage> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '09:00';
  int duration = 1;
  String selectedPaymentMethod = 'cash';
  bool isLoading = false;
  String? errorMessage;

  final List<String> availableTimes = [
    '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  double calculateTotalPrice() {
    // Extract numeric value from price string (e.g., "200DH/Heure" -> 200)
    String priceStr = widget.fieldPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    double basePrice = double.tryParse(priceStr) ?? 0;
    return basePrice * duration;
  }

  Future<void> makeReservation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Convert price string to numeric value
      String priceStr = widget.fieldPrice.replaceAll(RegExp(r'[^0-9.]'), '');
      double basePrice = double.tryParse(priceStr) ?? 0;
      
      // Format date in ISO8601 format but without timezone
      final dateOnly = DateFormat('yyyy-MM-dd').format(selectedDate);
      
      final Map<String, dynamic> reservationData = {
        'fieldId': widget.fieldId,
        'userId': 'temp_user_id', // Replace with actual user ID when auth is implemented
        'date': dateOnly,
        'startTime': selectedTime,
        'duration': duration,
        'totalPrice': basePrice * duration,
        'paymentMethod': selectedPaymentMethod,
      };
      
      print('Creating reservation with data: $reservationData');
      
      // Skip the actual API call for now and simulate a successful response
      // This is a temporary solution until the backend is fixed
      Map<String, dynamic> mockResponse = {
        '_id': 'temp_reservation_id',
        'fieldId': widget.fieldId,
        'userId': 'temp_user_id',
        'date': dateOnly,
        'startTime': selectedTime,
        'duration': duration,
        'totalPrice': basePrice * duration,
        'paymentMethod': selectedPaymentMethod,
        'paymentStatus': 'pending'
      };
      
      // Process the successful reservation
      if (selectedPaymentMethod == 'credit_card' || selectedPaymentMethod == 'paypal') {
        // Navigate to payment page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              reservationId: mockResponse['_id'],
              amount: calculateTotalPrice(),
              paymentMethod: selectedPaymentMethod,
            ),
          ),
        );
      } else {
        // For cash payment, show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reservation Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Field: ${widget.fieldTitle}'),
                Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                Text('Time: $selectedTime'),
                Text('Duration: $duration hour(s)'),
                Text('Total Price: ${calculateTotalPrice()}DH'),
                Text('Payment Method: ${selectedPaymentMethod.toUpperCase()}'),
                const Text('\nPlease pay in cash at the field.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Return to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        // Make error message more user-friendly
        String friendlyError = e.toString();
        
        if (friendlyError.contains('server configuration')) {
          friendlyError = 'Cannot connect to server. Please check your internet connection and try again.';
        } else if (friendlyError.contains('Failed to create reservation')) {
          friendlyError = 'Unable to make reservation. Please try again later.';
        }
        
        errorMessage = friendlyError;
      });
      print('Error making reservation: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2133),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2133),
        title: const Text('Make Reservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fieldTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.fieldLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price: ${widget.fieldPrice}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                // Date Selection
                ListTile(
                  title: const Text('Select Date'),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                // Time Selection
                ListTile(
                  title: const Text('Select Time'),
                  subtitle: DropdownButton<String>(
                    value: selectedTime,
                    isExpanded: true,
                    items: availableTimes.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedTime = newValue;
                        });
                      }
                    },
                  ),
                ),
                // Duration Selection
                ListTile(
                  title: const Text('Duration (hours)'),
                  subtitle: Slider(
                    value: duration.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    label: duration.toString(),
                    onChanged: (double value) {
                      setState(() {
                        duration = value.round();
                      });
                    },
                  ),
                ),
                // Payment Method Selection
                ListTile(
                  title: const Text('Payment Method'),
                  subtitle: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Cash'),
                        value: 'cash',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Credit Card'),
                        value: 'credit_card',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('PayPal'),
                        value: 'paypal',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Total Price
                ListTile(
                  title: const Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '${calculateTotalPrice()}DH',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.shade100,
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2133),
                    ),
                    onPressed: isLoading ? null : makeReservation,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Confirm Reservation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
