import 'package:flutter/material.dart';
import 'BasePage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _saveCard = true; // Checkbox state, initially checked

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Payment',
      currentIndex: 2, // Set the appropriate index for the footer navigation
      body: SingleChildScrollView(
        // Wrap the content in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pay with',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Credit card'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Google Pay'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Paypal'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Card number',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white, // Set white background
                  filled: true, // Enable the fill color
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Card holder',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white, // Set white background
                  filled: true, // Enable the fill color
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Expiration date',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white, // Set white background
                        filled: true, // Enable the fill color
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white, // Set white background
                        filled: true, // Enable the fill color
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _saveCard,
                    onChanged: (value) {
                      setState(() {
                        _saveCard = value ?? false; // Update the checkbox state
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Save my card for future reservation',
                      style: const TextStyle(
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add payment confirmation logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Center(
                  child: Text('Confirmer et payer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
