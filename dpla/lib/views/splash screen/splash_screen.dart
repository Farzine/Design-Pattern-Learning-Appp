import 'dart:async';
import 'package:dpla/core/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dpla/controllers/routes/app_routes.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  // /// Checks token and navigates to the appropriate screen.
  // Future<void> _checkTokenStatus() async {
  //   final token = await TokenStorage.getToken();

  //   if (token != null) {
  //     // Navigate to Home Screen if token exists
  //     Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  //   } else {
  //     // Navigate to Login Screen if no token exists
  //     Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // Simulate a short delay for splash effect
    Timer(const Duration(seconds: 5), () async {
      await _checkOnboardingStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Lottie.asset(
          'assets/initial.json', 
          fit: BoxFit.cover,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
