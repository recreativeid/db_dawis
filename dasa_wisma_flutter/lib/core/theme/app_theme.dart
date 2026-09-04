import 'package:flutter/material.dart';

class AppTheme {
  // Canva Design Exact Palette
  static const Color primaryBlue = Color(0xFF2563EB);    // Vibrant Royal Blue
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color accentBlue = Color(0xFF3B82F6);
  
  static const Color backgroundLight = Color(0xFFF8FAFC); // Off-white / Slate 50 background
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E8F0);
  
  static const Color textDark = Color(0xFF1E293B);      // Slate 800
  static const Color textMedium = Color(0xFF64748B);    // Slate 500
  static const Color textLight = Color(0xFF94A3B8);     // Slate 400
  
  // Stat Card Pastel Accents
  static const Color softBlueBg = Color(0xFFEFF6FF);
  static const Color softBlueText = Color(0xFF2563EB);
  
  static const Color softGreenBg = Color(0xFFECFDF5);
  static const Color softGreenText = Color(0xFF10B981);
  
  static const Color softYellowBg = Color(0xFFFEF3C7);
  static const Color softYellowText = Color(0xFFD97706);
  
  static const Color softPurpleBg = Color(0xFFF3E8FF);
  static const Color softPurpleText = Color(0xFF8B5CF6);
  
  static const Color softPinkBg = Color(0xFFFDF2F8);
  static const Color softPinkText = Color(0xFFDB2777);

  static const Color dangerRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFD97706);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Segoe UI',
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentBlue,
        surface: cardColor,
        error: dangerRed,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textDark),
      ),
    );
  }
}
