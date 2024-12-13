// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../main_navigation.dart';
import '../splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => const SplashScreen(),
    onboarding: (BuildContext context) => const OnboardingScreen(),
    login: (BuildContext context) => const LoginScreen(),
    register: (BuildContext context) => const RegisterScreen(),
    home: (BuildContext context) => MainNavigation(),
  };
}
