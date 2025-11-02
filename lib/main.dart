// lib/main.dart
import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'pages/auth/splash_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/regist_page.dart';
import 'pages/home/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import '/services/notif.dart';
import 'pages/profile/feedback_page.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await NotificationService().init();
  await NotificationService().requestPermissions();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scout Regiment Companion',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      
      // Initial route
      initialRoute: '/',
      
      // Routes
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/feedback': (context) => FeedbackPage(),
      },
      
      // Error handling
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Page not found: ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}