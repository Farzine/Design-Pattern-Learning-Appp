import 'package:dpla/views/navigation%20screen/profile%20screen/profile_main_screen.dart';
import 'package:flutter/material.dart';
import '../navigation screen/dashboard_screen.dart';
import '../navigation screen/dp screen/dp_list_screen.dart';
import '../navigation screen/social screen/home_screen.dart';
import 'circular_bottom_navigation.dart';
import 'navigation_tabs.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedPos = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedPos);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const DpListScreen(),
    const DashboardScreen(),
    const ProfileMainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            selectedPos = index;
          });
        },
      ),
      bottomNavigationBar: CircularBottomNavigation(
        getNavigationTabs(),
        selectedPos: selectedPos,
        barHeight: 60,
        circleSize: 60,
        circleStrokeWidth: 4,
        iconsSize: 30,
        selectedIconColor: Colors.white,
        normalIconColor: Colors.black54,
        animationDuration: const Duration(milliseconds: 300),
        selectedCallback: (index) {
          if (index != null && index != selectedPos) {
            setState(() {
              selectedPos = index;
              _pageController.jumpToPage(index);
            });
          }
        },
        allowSelectedIconCallback: true,
      ),
    );
  }
}
