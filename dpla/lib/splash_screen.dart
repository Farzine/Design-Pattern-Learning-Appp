// lib/splash_screen.dart

import 'dart:async';
import 'package:dpla/core/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dpla/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  /// Checks token and navigates to the appropriate screen.
  Future<void> _checkTokenStatus() async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      // Navigate to Home Screen if token exists
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      // Navigate to Login Screen if no token exists
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  /// Checks if the user has already seen the onboarding screens.
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      // Navigate to Login Screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      // Navigate to Onboarding Screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  void initState() {
    super.initState();
    // Simulate a short delay for splash effect
    Timer(const Duration(seconds: 2), _checkOnboardingStatus);
    Timer(const Duration(seconds: 2), _checkTokenStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          height: 150,
        ),
      ),
    );
  }
}
