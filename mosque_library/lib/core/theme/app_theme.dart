import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    return base.copyWith(
      scaffoldBackgroundColor: ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkGreen,
        primary: darkGreen,
        secondary: gold,
        surface: warmSurface,
      ),
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: warmSurface,
        hintStyle: const TextStyle(color: muted, fontSize: 14),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFB8B29F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: darkGreen, width: 1.6),
        ),
      ),
    );
  }
}
