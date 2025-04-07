import 'package:flutter/material.dart';
import 'services/api_service.dart';

class PaymentPage extends StatefulWidget {
  final String reservationId;
  final double amount;
  final String paymentMethod;

  const PaymentPage({
    Key? key,
    required this.reservationId,
    required this.amount,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> processPayment() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Here you would integrate with your payment gateway
      // For now, we'll just simulate a successful payment
      await Future.delayed(const Duration(seconds: 2));
      
      // Skip the API call to update status and just show success
      // await ApiService.updatePaymentStatus(widget.reservationId, 'completed');

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: ${widget.amount}DH'),
                Text('Payment Method: ${widget.paymentMethod == 'credit_card' ? 'Credit Card' : 'PayPal'}'),
                const Text('\nYour reservation has been confirmed.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
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
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.paymentMethod == 'credit_card' 
                            ? Icons.credit_card
                            : Icons.payment,
                        size: 28,
                        color: const Color(0xFF0B2133),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.paymentMethod == 'credit_card' 
                                ? 'Credit Card Payment'
                                : 'PayPal Payment',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ${widget.amount}DH',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment form
                if (widget.paymentMethod == 'credit_card') ...[
                  TextField(
                    controller: cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: Icon(Icons.credit_card, color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      hintText: 'John Doe',
                      prefixIcon: Icon(Icons.person, color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ] else if (widget.paymentMethod == 'paypal') ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/1200px-PayPal.svg.png',
                          height: 40,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'You will be redirected to PayPal to complete your payment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Amount: ${widget.amount}DH',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 30),
                
                // Payment button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2133),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : processPayment,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            widget.paymentMethod == 'paypal'
                                ? 'Continue to PayPal'
                                : 'Pay Now',
                            style: const TextStyle(
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
