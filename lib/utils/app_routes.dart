import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/home_screen.dart';
import '../views/settings_screen.dart';
import '../views/bookmarks_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/phone_login_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String phoneLogin = '/phone-login';
  static const String home = '/home';
  static const String bookmarks = '/bookmarks';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;

    if (routeName == splash) {
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );
    }

    if (routeName == login) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      );
    }

    if (routeName == signup) {
      return MaterialPageRoute(
        builder: (_) => const SignupScreen(),
      );
    }

    if (routeName == phoneLogin) {
      return MaterialPageRoute(
        builder: (_) => const PhoneLoginScreen(),
      );
    }

    if (routeName == home) {
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      );
    }

    if (routeName == bookmarks) {
      return MaterialPageRoute(
        builder: (_) => const BookmarksScreen(),
      );
    }

    if (routeName == settings) {
      return MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      );
    }

    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    );
  }
}