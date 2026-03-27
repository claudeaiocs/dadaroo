import 'package:flutter/material.dart';
import 'package:dadaroo/config/app_config.dart';

class AppTheme {
  static Color get primaryOrange => appConfig.primaryColor;
  static Color get darkBrown => appConfig.darkAccent;
  static Color get warmBrown => appConfig.warmAccent;
  static Color get lightOrange => appConfig.lightAccent;
  static Color get cream => appConfig.cream;
  static Color get accentYellow => appConfig.accentHighlight;
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
