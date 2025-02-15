import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dpla/views/auth/login_screen.dart';

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
      'description':
          'Welcome to the Design Pattern Learning App! Learn and master various design patterns to enhance your software development skills.',
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
      'description':
          'Welcome to DP Learning App! Start your journey by logging in or registering to access all features.',
      'isSwipe': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    // Auto-advance only on the first page
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

    // Navigate to LoginScreen with a fade transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
      // Use a gradient background for the entire screen
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade600, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // A Stack so we can place the dot indicator in a fixed position
        child: Stack(
          children: [
            // PageView for Onboarding
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16),
                    child: _buildOnboardingPage(data),
                  ),
                );
              },
            ),

            // Fixed Dot Indicator at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildDotIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> data) {
    final bool isLast = _onboardingData.indexOf(data) ==
        _onboardingData.length - 1;

    return Column(
      children: [
        // Card-like container for each onboarding page
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: _buildPageContent(data, isLast),
          ),
        ),
      ],
    );
  }

  Widget _buildPageContent(Map<String, dynamic> data, bool isLast) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display image with some animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Image.asset(
            data['image'],
            key: ValueKey<String>(data['image']),
            height: 160,
          ),
        ),
        const SizedBox(height: 30),

        // Display title
        Text(
          data['title'],
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),

        // Display description
        Text(
          data['description'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const Spacer(),

        // Next/Done Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () async {
            if (isLast) {
              // Finish Onboarding
              await _completeOnboarding();
            } else {
              final currentIndex = _onboardingData.indexOf(data);
              if (currentIndex < _onboardingData.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
          child: Icon(
            Icons.arrow_forward,
            color: Colors.purple.shade400,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: List.generate(_onboardingData.length, (index) {
        final isActive = (index == _currentPage);

        // We use an AnimatedScale + AnimatedContainer for a subtle scale effect
        return AnimatedScale(
          scale: isActive ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.white : Colors.white54,
            ),
          ),
        );
      }),
    );
  }
}
