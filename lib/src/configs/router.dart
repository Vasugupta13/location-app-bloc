import 'package:parkin_assessment/src/presentation/screens/home/home_screen.dart';
import 'package:parkin_assessment/src/presentation/screens/login/login_screen.dart';
import 'package:parkin_assessment/src/presentation/screens/signup/signup_screen.dart';
import 'package:parkin_assessment/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String HOME = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case LOGIN:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case SIGNUP:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      case HOME:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  ///Singleton factory
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._internal();
}
