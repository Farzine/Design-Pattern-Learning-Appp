// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/routes/app_routes.dart';
import 'package:dpla/config/theme.dart';
import 'screens/onboarding_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DesignPatternApp(),
    ),
  );
}

class DesignPatternApp extends ConsumerWidget {
  const DesignPatternApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Design Pattern Learning App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash, // Set initial route to Splash
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
