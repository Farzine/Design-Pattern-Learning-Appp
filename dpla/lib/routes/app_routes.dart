// lib/app_routes.dart
import 'package:flutter/material.dart';
import 'package:dpla/screens/auth/login_screen.dart';
import 'package:dpla/screens/auth/register_screen.dart';
import 'package:dpla/screens/home_screen.dart';

class AppRoutes {
  static const initialRoute = '/login';

  static Map<String, WidgetBuilder> get routes => {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        // Add more routes as needed
      };
}
