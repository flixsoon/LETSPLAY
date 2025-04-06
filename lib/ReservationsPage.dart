import 'package:flutter/material.dart';

class ReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Reservations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey[900], // Consistent app bar color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5), // Same background color as BasePage
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ReservationCard(
              imageUrl:
                  'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
              location: 'Rabat-Salé',
              field: 'Bettana-Salé',
              date: '12/12/2025 08:00-09:00',
              status: 'En cours',
            ),
            ReservationCard(
              imageUrl:
                  'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
              location: 'Rabat-Salé',
              field: 'Marina-Salé',
              date: '12/12/2025 18:00-19:00',
              status: 'En cours',
            ),
            ReservationCard(
              imageUrl:
                  'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
              location: 'Rabat-Salé',
              field: 'Bettana-Salé',
              date: '12/12/2025 18:00-19:00',
              status: 'Terminé',
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String imageUrl;
  final String location;
  final String field;
  final String date;
  final String status;

  const ReservationCard({
    required this.imageUrl,
    required this.location,
    required this.field,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          location,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              field,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                color: status == 'En cours' ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
