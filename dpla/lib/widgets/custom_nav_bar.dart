// lib/widgets/custom_nav_bar.dart

import 'package:flutter/material.dart';
import '../screens/notification_screen.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoPath;
  final TextEditingController searchController;

  const CustomNavBar({
    Key? key,
    required this.logoPath,
    required this.searchController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Navigates the user to the Notification Page.
  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.purple.shade100, // Navbar background color
      elevation: 2.0, // Shadow elevation
      title: Row(
        children: [
          // Logo Image
          Image.asset(
            logoPath,
            height: 40, // Adjust the height as needed
          ),
          const SizedBox(width: 16.0),
          // Expanded Search Bar
          Expanded(
            child: Container(
              height: 40, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.white, // Search bar background color
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Notification Icon
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () => _navigateToNotifications(context),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}
