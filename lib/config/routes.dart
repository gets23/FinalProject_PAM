// lib/config/routes.dart
import 'package:flutter/material.dart';
import '/pages/auth/splash_screen.dart';
import '/pages/profile/pfp_page.dart';
import '/pages/profile/feedback_page.dart';
import '/pages/tools/curr_conv_page.dart';
import '/pages/tools/time_conv_page.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static final routes = {
    splash: (context) => SplashScreen(),
  };
  
  // Characters
  static const String characters = '/characters';
  static const String characterDetail = '/character-detail';
  static const String favorites = '/favorites';
  
  // Episodes
  static const String episodes = '/episodes';
  static const String episodeDetail = '/episode-detail';
  
  // Map
  static const String map = '/map';
  static const String locationDetail = '/location-detail';
  
  // Tools
  static const String currencyConverter = '/currency-converter';
  static const String timeConverter = '/time-converter';
  
  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String feedback = '/feedback';
  static const String settings = '/settings';

  // Generate Routes (akan diimplementasikan nanti)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Ini akan kita implement setelah semua pages dibuat
    switch (settings.name) {
      case splash:
        // return MaterialPageRoute(builder: (_) => SplashScreen());
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Splash Screen')),
          ),
        );
      
      case login:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Login Page')),
          ),
        );
      
      case register:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Register Page')),
          ),
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Home Page')),
          ),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      
      case AppRoutes.feedback:
        return MaterialPageRoute(builder: (_) => FeedbackPage());

      case AppRoutes.currencyConverter:
        return MaterialPageRoute(builder: (_) => CurrencyConverterPage());

      case AppRoutes.timeConverter:
        return MaterialPageRoute(builder: (_) => TimeConverterPage());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Page not found: ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Helper method untuk navigation
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemove(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}