import 'package:flutter/material.dart';
import 'BasePage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Home',
      currentIndex: 0,
      body: const Center(
        child: Text(
          'Home Page Content',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
