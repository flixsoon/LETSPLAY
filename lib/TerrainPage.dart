// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for formatting the date
import 'BasePage.dart';

class TerrainPage extends StatefulWidget {
  const TerrainPage({Key? key}) : super(key: key);

  @override
  _TerrainPageState createState() => _TerrainPageState();
}

class _TerrainPageState extends State<TerrainPage> {
  final List<Map<String, String>> _messages = [
    {
      'message': 'Hey, what time is the match starting?',
      'isSender': 'false',
      'time': '2 mins ago'
    },
    {
      'message': 'It starts at 5 PM. Don’t be late!',
      'isSender': 'true',
      'time': '2 mins ago'
    },
    {
      'message': 'Got it! Are we playing on the same field as last time?',
      'isSender': 'false',
      'time': '1 min ago'
    },
    {
      'message': 'Yes, the Bettana field. Make sure to bring your gear.',
      'isSender': 'true',
      'time': 'Just now'
    },
  ];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Get the current time and format it
    final String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    setState(() {
      _messages.add({
        'message': _messageController.text.trim(),
        'isSender': 'true',
        'time': currentTime, // Use the formatted current time
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Terrain',
      currentIndex: 3, // Set the appropriate index for the footer navigation
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildChatSection(),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Updated background color
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green, // Updated avatar color to green
                child: const Icon(Icons.group, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                '8/8 Players',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey, // Updated text color
                ),
              ),
            ],
          ),
          const Text(
            'Chat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey, // Updated text color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 6, // Increased elevation for a modern look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/0a/Santiagobernabeupanoramav45.JPG',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Bettana Football Field',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Updated text color
                    ),
                  ),
                  Text(
                    '4.55 (93)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey, // Updated text color
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

  Widget _buildChatSection() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return _buildChatBubble(
            message: message['message']!,
            isSender: message['isSender'] == 'true',
            time: message['time']!,
          );
        },
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100, // Updated shadow color
            blurRadius: 6, // Increased blur for a softer shadow
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.blue.shade50, // Updated input field color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send,
                color: Colors.green), // Updated icon color to green
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String message,
    required bool isSender,
    required String time,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender
              ? Colors.green.shade100 // Updated sender bubble color to green
              : Colors.grey.shade200, // Receiver bubble color remains the same
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSender ? 16 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black87), // Updated text color
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                  fontSize: 12, color: Colors.blueGrey), // Updated time color
            ),
          ],
        ),
      ),
    );
  }
}
