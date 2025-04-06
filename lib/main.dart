import 'package:flutter/material.dart';
import 'JouerPage.dart'; // Import the JouerPage
import 'MorePage.dart'; // Import the MorePage
import 'ReserverPage.dart'; // Import the ReserverPage
import 'TerrainPage.dart'; // Import the TerrainPage
import 'services/mongo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await testMongoConnection(); // Test the MongoDB connection
  runApp(FlutterApp());
}

Future<void> testMongoConnection() async {
  try {
    await MongoService.connect();
    print('MongoDB connection successful!');
  } catch (e) {
    print('MongoDB connection failed: $e');
  }
}

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLocation = 'Maroc, Rabat'; // Default selected location
  int _currentIndex = 0; // Track the selected index
  TextEditingController _searchController =
      TextEditingController(); // Controller for search input
  List<Map<String, dynamic>> allFields = [
    {
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
      'title': 'Terrain Bettana',
      'location': 'Rabat-Salé (~2.4 kms)',
      'price': '200DH/Heure',
      'rating': 4.55,
      'reviews': 93,
    },
    {
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
      'title': 'Taqadum Football Club',
      'location': 'Rabat-Salé (~2.4 kms)',
      'price': '200DH/Heure',
      'rating': 4.44,
      'reviews': 50,
    },
  ];
  List<Map<String, dynamic>> filteredFields = [];

  @override
  void initState() {
    super.initState();
    filteredFields = allFields; // Initialize with all fields
    _searchController
        .addListener(_filterFields); // Listen to search input changes
  }

  void _filterFields() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFields = allFields
          .where((field) => field['title'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _updateFields(String location) {
    setState(() {
      if (location == 'Maroc, Rabat') {
        allFields = [
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Terrain Bettana',
            'location': 'Rabat-Salé (~2.4 kms)',
            'price': '200DH/Heure',
            'rating': 4.55,
            'reviews': 93,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Taqadum Football Club',
            'location': 'Rabat-Salé (~2.4 kms)',
            'price': '200DH/Heure',
            'rating': 4.44,
            'reviews': 50,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Stade Moulay Abdellah',
            'location': 'Rabat (~5.0 kms)',
            'price': '300DH/Heure',
            'rating': 4.75,
            'reviews': 120,
          },
        ];
      } else if (location == 'Maroc, Salé') {
        allFields = [
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Terrain Salé Medina',
            'location': 'Salé (~1.5 kms)',
            'price': '150DH/Heure',
            'rating': 4.25,
            'reviews': 80,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Club Salé',
            'location': 'Salé (~3.0 kms)',
            'price': '180DH/Heure',
            'rating': 4.35,
            'reviews': 60,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Stade Salé',
            'location': 'Salé (~2.0 kms)',
            'price': '250DH/Heure',
            'rating': 4.65,
            'reviews': 100,
          },
        ];
      } else if (location == 'Maroc, Témara') {
        allFields = [
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Terrain Témara Centre',
            'location': 'Témara (~2.0 kms)',
            'price': '200DH/Heure',
            'rating': 4.50,
            'reviews': 70,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Club Témara',
            'location': 'Témara (~3.5 kms)',
            'price': '220DH/Heure',
            'rating': 4.60,
            'reviews': 90,
          },
          {
            'imageUrl':
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
            'title': 'Stade Témara',
            'location': 'Témara (~1.0 kms)',
            'price': '250DH/Heure',
            'rating': 4.80,
            'reviews': 110,
          },
        ];
      }
      filteredFields = allFields; // Update the filtered list
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected index
    });

    // Navigate to the corresponding page
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ReserverPage(
                  fieldTitle: 'Sample Title',
                  fieldLocation: 'Sample Location',
                  fieldPrice: 'Sample Price',
                )),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedLocation, // Bind to the state variable
              dropdownColor: const Color(0xFF0B2133),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Maroc, Rabat',
                  child: Text('Maroc, Rabat'),
                ),
                DropdownMenuItem(
                  value: 'Maroc, Salé',
                  child: Text('Maroc, Salé'),
                ),
                DropdownMenuItem(
                  value: 'Maroc, Témara',
                  child: Text('Maroc, Témara'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!; // Update the selected location
                  _updateFields(
                      selectedLocation); // Update the fields based on the selected location
                });
              },
            ),
            Row(
              children: [
                Icon(Icons.message,
                    color: Colors.white), // Replaced "+" with message icon
                const SizedBox(width: 16),
                Icon(Icons.notifications, color: Colors.white),
                const SizedBox(width: 16),
                Icon(Icons.person, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0B2133),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Search Bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController, // Bind the controller
                          decoration: InputDecoration(
                            hintText: 'Rechercher un Terrain',
                            hintStyle: const TextStyle(
                              color: Color(0xFF808E89),
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.search, color: const Color(0xFF808E89)),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Buttons Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Filter Button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEE1E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.filter_alt,
                          color: const Color(0xFF323842)),
                    ),
                    // Special Offer Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEE1E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.card_giftcard,
                              color: const Color(0xFF323842)),
                          const SizedBox(width: 8),
                          const Text(
                            'Offre Special (3)',
                            style: TextStyle(
                              color: Color(0xFF323842),
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Favorites Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFEFF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEBEBEB)),
                      ),
                      child: const Text(
                        'Favoris',
                        style: TextStyle(
                          color: Color(0xFF424846),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Results and Events Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Resultats (51)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const Text(
                      'Évenements (0)',
                      style: TextStyle(
                        color: Color(0xFF808E89),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List of Fields
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFields.length,
              itemBuilder: (context, index) {
                final field = filteredFields[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReserverPage(
                          fieldTitle: field['title'], // Pass the field title
                          fieldLocation:
                              field['location'], // Pass the field location
                          fieldPrice: field['price'], // Pass the field price
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      FieldCard(
                        imageUrl: field['imageUrl'],
                        title: field['title'],
                        location: field['location'],
                        price: field['price'],
                        rating: field['rating'],
                        reviews: field['reviews'],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B2133), // Same color as the header
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF808E89),
        type: BottomNavigationBarType.fixed, // Ensures all items are displayed
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        selectedFontSize: 12, // Adjust font size for selected labels
        unselectedFontSize: 12, // Adjust font size for unselected labels
        currentIndex: _currentIndex, // Set the current index to "Home"
        onTap: _onItemTapped,
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

class FieldCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final double rating;
  final int reviews;

  const FieldCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    Key? key,
  }) : super(key: key);

  @override
  _FieldCardState createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  bool isFavorite = false; // Track the favorite state

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the favorite state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              widget.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prix: ${widget.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.rating} (${widget.reviews})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _toggleFavorite, // Handle heart icon tap
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
