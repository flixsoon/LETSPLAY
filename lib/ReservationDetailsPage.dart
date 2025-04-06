import 'package:flutter/material.dart';
import 'package:letsplay/PaymentPage.dart';
import 'BasePage.dart';

class ReservationDetailsPage extends StatelessWidget {
  final DateTime selectedDay;
  final String selectedTimeSlot;

  const ReservationDetailsPage({
    Key? key,
    required this.selectedDay,
    required this.selectedTimeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Reservation Details',
      currentIndex: 2, // Set the appropriate index for the footer navigation
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Date: ${selectedDay.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Time Slot: $selectedTimeSlot',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirm Reservation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
