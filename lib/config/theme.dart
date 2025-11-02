// lib/config/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // ==================== COLORS ====================
  
  // Primary Color - Dark Brown (Survey Corps)
  static const Color primaryColor = Color(0xFF2C2416);
  
  // Secondary Color - Gold (Wings of Freedom)
  static const Color secondaryColor = Color(0xFFC8B273);
  
  // Accent Color - Dark Red (Titans)
  static const Color accentColor = Color(0xFF8B0000);
  
  // Background Color - Parchment
  static const Color backgroundColor = Color(0xFFF5E6D3);
  
  // Text Color - Dark Gray
  static const Color textColor = Color(0xFF1A1A1A);
  
  // Success Color
  static const Color successColor = Color(0xFF4CAF50);
  
  // Error Color
  static const Color errorColor = Color(0xFFE53935);
  
  // Warning Color
  static const Color warningColor = Color(0xFFFFA726);
  
  // Info Color
  static const Color infoColor = Color(0xFF42A5F5);
  
  // ==================== TEXT STYLES ====================
  
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 1.5,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 1.2,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 1,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textColor,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textColor,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: textColor,
    letterSpacing: 0.2,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: Color(0xFF666666),
    letterSpacing: 0.1,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
  
  // ==================== THEME DATA ====================
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: Colors.white,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
          letterSpacing: 1,
        ),
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // OutlinedButton Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor, width: 2),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // TextButton Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: textColor),
        hintStyle: TextStyle(color: textColor),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accentColor,
        unselectedItemColor: textColor,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor,
        deleteIconColor: accentColor,
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: primaryColor,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingMedium,
        displaySmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelSmall: caption,
      ),
    );
  }
  
  // ==================== BOX DECORATIONS ====================
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration primaryGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, primaryColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
  
  static BoxDecoration accentGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [accentColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}