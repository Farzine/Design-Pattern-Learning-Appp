// lib/screens/onboarding_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dpla/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'DP Learning App',
      'image': 'assets/logo.png',
      'description': 'Welcome to the Design Pattern Learning App! Learn and master various design patterns to enhance your software development skills.',
      'isLoading': true,
    },
    {
      'title': 'Course Catalogue',
      'image': 'assets/courses.png',
      'description':
          'Organize courses into categories and subcategories for easy browsing. It includes course titles and descriptions to help you choose the right path.',
    },
    {
      'title': 'Course Content Management',
      'image': 'assets/course_content.png',
      'description':
          'Ability to bookmark or save courses for later viewing. Track your progress within each course and continue learning seamlessly.',
    },
    {
      'title': 'Hello Learner!',
      'image': 'assets/hi.gif',
      'description': 'Welcome to DP Learning App! Start your journey by logging in or registering to access all features.',
      'isSwipe': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    // Start auto-advance only on the first page
    if (_currentPage == 0) {
      _autoAdvanceTimer = Timer(const Duration(seconds: 3), () {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // Cancel any existing timer
    _autoAdvanceTimer?.cancel();

    if (_currentPage == 0) {
      _startAutoAdvance();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Set the flag in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    // Navigate to LoginScreen with animation
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final data = _onboardingData[index];
          return Container(
            color: Colors.purple[400],
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display image
                Image.asset(
                  data['image'],
                  height: 200,
                ),
                const SizedBox(height: 30),
                // Display title
                Text(
                  data['title'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Display description
                Text(
                  data['description'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                // Display button
                if (index == _onboardingData.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () async {
                      // Show animation here if needed
                      await _completeOnboarding();
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.purple[400],
                      size: 30,
                    ),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.purple[400],
                      size: 30,
                    ),
                  ),
                const SizedBox(height: 20),
                // Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_onboardingData.length, (dotIndex) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == dotIndex ? 12.0 : 8.0,
                      height: _currentPage == dotIndex ? 12.0 : 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == dotIndex ? Colors.white : Colors.white54,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
