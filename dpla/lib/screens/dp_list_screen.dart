// lib/screens/take_exam_screen.dart

import 'package:flutter/material.dart';
import '../widgets/custom_nav_bar.dart';

class DpListScreen extends StatelessWidget {
  const DpListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the search bar
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: CustomNavBar(
        logoPath: 'assets/logo.png', // Path to your logo asset
        searchController: _searchController,
      ),
      body: const Center(
        child: Text(
          'DP List Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
