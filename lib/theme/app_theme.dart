import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF4F46E5); // indigo

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.light,
        cardTheme: const CardThemeData(elevation: 0),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        cardTheme: const CardThemeData(elevation: 0),
      );
}
