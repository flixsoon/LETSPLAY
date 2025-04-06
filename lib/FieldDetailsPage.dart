import 'package:flutter/material.dart';

class FieldDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final double rating;
  final int reviews;

  const FieldDetailsPage({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B2133), // Match BasePage background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2133), // Match BasePage AppBar color
        title: Text(
          title,
          style: const TextStyle(color: Colors.white), // White text for AppBar
        ),
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with loading and error handling
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // Grey text for secondary info
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Text(
                    'Prix: $price',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '$rating ($reviews reviews)',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is a detailed description of the field. You can add more information here about the field, its facilities, and other details.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
