import 'package:flutter/material.dart';
import 'package:app/features/splash/screens/splash_screen.dart';
import 'package:app/features/home/screens/home_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Unknown Route'),),
            ));

    }
  }
}