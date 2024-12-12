// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  /// Placeholder Home Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Patterns'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Design Pattern Learning App!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
