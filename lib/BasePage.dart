import 'package:flutter/material.dart';
import 'main.dart'; // Import HomePage
import 'JouerPage.dart'; // Import JouerPage
import 'ReserverPage.dart'; // Import ReserverPage
import 'TerrainPage.dart'; // Import TerrainPage
import 'MorePage.dart'; // Import MorePage

class BasePage extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;

  const BasePage({
    required this.title,
    required this.currentIndex,
    required this.body,
    Key? key,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => JouerPage()),
      );
    } else if (index == 2) {
      // Navigate to ReserverPage with placeholder values
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReserverPage(
            fieldTitle: 'Default Title', // Placeholder title
            fieldLocation: 'Default Location', // Placeholder location
            fieldPrice: 'Default Price', // Placeholder price
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TerrainPage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MorePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2133),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2133),
        elevation: 0,
        title: Text(title),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B2133),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF808E89),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Jouer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reserver',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Terrain',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
