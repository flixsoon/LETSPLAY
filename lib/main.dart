import 'package:flutter/material.dart';
import 'JouerPage.dart'; // Import the JouerPage
import 'MorePage.dart'; // Import the MorePage
import 'ReserverPage.dart'; // Import the ReserverPage
import 'TerrainPage.dart'; // Import the TerrainPage
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlutterApp());
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
  String selectedLocation = 'All Locations'; // Default selected location
  int _currentIndex = 0; // Track the selected index
  TextEditingController _searchController =
      TextEditingController(); // Controller for search input
  List<Map<String, dynamic>> allFields = [];
  List<Map<String, dynamic>> filteredFields = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Filter and sort variables
  double minPrice = 0;
  double maxPrice = 1000;
  double minRating = 0;
  List<String> selectedAmenities = [];
  String sortBy = 'name'; // 'name', 'price', 'rating'
  bool sortAscending = true;
  
  // Available amenities for filtering
  final List<String> availableAmenities = [
    'Parking', 'Wifi', 'Showers', 'Cafeteria', 'Lockers', 'VIP Lounge', 'Restaurant', 'Small Shop'
  ];

  @override
  void initState() {
    super.initState();
    _loadFields();
    _searchController
        .addListener(_filterFields); // Listen to search input changes
  }

  Future<void> _loadFields() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      final fields = await ApiService.getFields();
      setState(() {
        allFields = fields;
        _applyFiltersAndSort();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load fields: $e';
        isLoading = false;
      });
    }
  }

  void _filterFields() {
    _applyFiltersAndSort();
  }

  void _updateFields(String location) {
    setState(() {
      selectedLocation = location;
      _applyFiltersAndSort();
    });
  }
  
  void _applyFiltersAndSort() {
    // Start with all fields
    List<Map<String, dynamic>> result = List.from(allFields);
    
    // Apply location filter
    if (selectedLocation != 'All Locations') {
      result = result.where((field) => 
        field['location'].toLowerCase().contains(selectedLocation.toLowerCase())
      ).toList();
    }
    
    // Apply search filter
    String query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((field) => 
        field['title'].toLowerCase().contains(query)
      ).toList();
    }
    
    // Apply price filter
    result = result.where((field) {
      // Extract numeric price value from string (e.g., "200DH/Heure" -> 200)
      String priceStr = field['price'].toString();
      double price = 0;
      try {
        price = double.parse(priceStr.replaceAll(RegExp(r'[^0-9.]'), ''));
      } catch (e) {
        // If parsing fails, use 0
      }
      return price >= minPrice && price <= maxPrice;
    }).toList();
    
    // Apply rating filter
    result = result.where((field) {
      double rating = field['rating']?.toDouble() ?? 0.0;
      return rating >= minRating;
    }).toList();
    
    // Apply amenities filter
    if (selectedAmenities.isNotEmpty) {
      result = result.where((field) {
        List<dynamic> fieldAmenities = field['amenities'] ?? [];
        return selectedAmenities.every((amenity) => 
          fieldAmenities.contains(amenity)
        );
      }).toList();
    }
    
    // Apply sorting
    result.sort((a, b) {
      int comparison = 0;
      
      switch (sortBy) {
        case 'name':
          comparison = a['title'].toString().compareTo(b['title'].toString());
          break;
        case 'price':
          // Extract numeric price values
          double priceA = 0;
          double priceB = 0;
          try {
            priceA = double.parse(a['price'].toString().replaceAll(RegExp(r'[^0-9.]'), ''));
            priceB = double.parse(b['price'].toString().replaceAll(RegExp(r'[^0-9.]'), ''));
          } catch (e) {
            // If parsing fails, use 0
          }
          comparison = priceA.compareTo(priceB);
          break;
        case 'rating':
          double ratingA = a['rating']?.toDouble() ?? 0.0;
          double ratingB = b['rating']?.toDouble() ?? 0.0;
          comparison = ratingA.compareTo(ratingB);
          break;
      }
      
      return sortAscending ? comparison : -comparison;
    });
    
    setState(() {
      filteredFields = result;
    });
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Create temporary variables to hold filter values
        double tempMinPrice = minPrice;
        double tempMaxPrice = maxPrice;
        double tempMinRating = minRating;
        List<String> tempSelectedAmenities = List.from(selectedAmenities);
        String tempSortBy = sortBy;
        bool tempSortAscending = sortAscending;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter and Sort Fields'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Range (DH):', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: RangeValues(tempMinPrice, tempMaxPrice),
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        tempMinPrice.round().toString(),
                        tempMaxPrice.round().toString()
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          tempMinPrice = values.start;
                          tempMaxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Minimum Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: tempMinRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: tempMinRating.toString(),
                      onChanged: (value) {
                        setState(() {
                          tempMinRating = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: availableAmenities.map((amenity) {
                        bool isSelected = tempSelectedAmenities.contains(amenity);
                        return FilterChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                tempSelectedAmenities.add(amenity);
                              } else {
                                tempSelectedAmenities.remove(amenity);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Sort By:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: tempSortBy,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'name', child: Text('Name')),
                        DropdownMenuItem(value: 'price', child: Text('Price')),
                        DropdownMenuItem(value: 'rating', child: Text('Rating')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tempSortBy = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        const Text('Sort Order:'),
                        const SizedBox(width: 8),
                        Switch(
                          value: tempSortAscending,
                          onChanged: (value) {
                            setState(() {
                              tempSortAscending = value;
                            });
                          },
                        ),
                        Text(tempSortAscending ? 'Ascending' : 'Descending'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset filters
                    Navigator.of(context).pop();
                    setState(() {
                      minPrice = 0;
                      maxPrice = 1000;
                      minRating = 0;
                      selectedAmenities = [];
                      sortBy = 'name';
                      sortAscending = true;
                      _applyFiltersAndSort();
                    });
                  },
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    setState(() {
                      minPrice = tempMinPrice;
                      maxPrice = tempMaxPrice;
                      minRating = tempMinRating;
                      selectedAmenities = tempSelectedAmenities;
                      sortBy = tempSortBy;
                      sortAscending = tempSortAscending;
                      _applyFiltersAndSort();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
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
            fieldTitle: 'Select a Field',
            fieldLocation: '',
            fieldPrice: '',
            fieldId: '',
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
                  value: 'All Locations',
                  child: Text('All Locations'),
                ),
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
                DropdownMenuItem(
                  value: 'Maroc, Casablanca',
                  child: Text('Maroc, Casablanca'),
                ),
                DropdownMenuItem(
                  value: 'Maroc, Marrakech',
                  child: Text('Maroc, Marrakech'),
                ),
                DropdownMenuItem(
                  value: 'Maroc, Fès',
                  child: Text('Maroc, Fès'),
                ),
                DropdownMenuItem(
                  value: 'Maroc, Tanger',
                  child: Text('Maroc, Tanger'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!; // Update the selected location
                  _updateFields(selectedLocation); // Update the fields based on the selected location
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
                    GestureDetector(
                      onTap: _showFilterDialog,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEE1E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.filter_alt,
                            color: const Color(0xFF323842)),
                      ),
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
                    Text(
                      'Resultats (${filteredFields.length})',
                      style: const TextStyle(
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadFields,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredFields.isEmpty
                        ? const Center(
                            child: Text(
                              'No fields found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
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
                                        fieldTitle: field['title'],
                                        fieldLocation: field['location'],
                                        fieldPrice: field['price'],
                                        fieldId: field['_id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    FieldCard(
                                      imageUrl: field['imageUrl'] ?? 'https://via.placeholder.com/300x150',
                                      title: field['title'],
                                      location: field['location'],
                                      price: field['price'],
                                      rating: field['rating']?.toDouble() ?? 0.0,
                                      reviews: field['reviews']?.toInt() ?? 0,
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
