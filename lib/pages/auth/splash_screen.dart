// lib/pages/auth/splash_screen.dart
// TEMPORARY VERSION - Langsung ke login untuk testing
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    print('🚀 [SPLASH] Splash screen initiated');
    
    // Setup animations
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // TEMPORARY: Langsung ke login tanpa auth check
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    try {
      print('⏳ [SPLASH] Waiting 2 seconds...');
      await Future.delayed(Duration(seconds: 2));
      
      print('➡️ [SPLASH] Navigating to login...');
      
      if (!mounted) {
        print('⚠️ [SPLASH] Widget not mounted, skipping navigation');
        return;
      }

      Navigator.pushReplacementNamed(context, '/login');
      print('✅ [SPLASH] Navigation successful');
      
    } catch (e, stackTrace) {
      print('❌ [SPLASH] Navigation error: $e');
      print('❌ [SPLASH] Stack trace: $stackTrace');
      
      // Fallback: Coba navigate lagi setelah delay
      if (mounted) {
        await Future.delayed(Duration(seconds: 1));
        try {
          Navigator.pushReplacementNamed(context, '/login');
        } catch (e2) {
          print('❌ [SPLASH] Second attempt failed: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    print('🔚 [SPLASH] Splash screen disposed');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 [SPLASH] Building splash screen UI');
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.military_tech,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App Name
                  Text(
                    'SCOUT REGIMENT',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Companion',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.secondaryColor.withOpacity(0.8),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dedicate Your Heart',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}