

// lib/widgets/navigation_tabs.dart

import 'package:flutter/material.dart';
import 'tab_item.dart';

List<TabItem> getNavigationTabs() {
  return [
    TabItem(
      Icons.home,
      'Home',
      Colors.purple.shade400, // Circle color when selected
      circleStrokeColor: Colors.purpleAccent, // Optional circle stroke color
      labelStyle: const TextStyle(color: Colors.black),
    ),
    TabItem(
      Icons.document_scanner,
      'DP List',
      Colors.purple.shade400,
      circleStrokeColor: Colors.purpleAccent,
      labelStyle: const TextStyle(color: Colors.black),
    ),
    TabItem(
      Icons.dashboard,
      'Dashboard',
      Colors.purple.shade400,
      circleStrokeColor: Colors.purpleAccent,
      labelStyle: const TextStyle(color: Colors.black),
    ),
    TabItem(
      Icons.person,
      'Profile',
      Colors.purple.shade400,
      circleStrokeColor: Colors.purpleAccent,
      labelStyle: const TextStyle(color: Colors.black),
    ),
  ];
}
