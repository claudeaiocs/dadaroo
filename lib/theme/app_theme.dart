import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFE8751A);
  static const Color darkBrown = Color(0xFF4A2C0A);
  static const Color warmBrown = Color(0xFF8B5E3C);
  static const Color lightOrange = Color(0xFFFFF3E0);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color accentYellow = Color(0xFFFFB74D);
  static const Color successGreen = Color(0xFF66BB6A);
  static const Color starGold = Color(0xFFFFD700);

  static ThemeData get theme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
      primary: primaryOrange,
      secondary: warmBrown,
      surface: cream,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkBrown,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryOrange.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryOrange,
            );
          }
          return TextStyle(fontSize: 12, color: warmBrown);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightOrange,
        selectedColor: primaryOrange,
        labelStyle: TextStyle(color: darkBrown),
      ),
    );
  }
}
