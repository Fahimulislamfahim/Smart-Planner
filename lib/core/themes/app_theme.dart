import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to avoid instantiation
  AppTheme._();

  static const _primaryColor = Color(0xFF6C63FF); // Modern Violet
  static const _secondaryColor = Color(0xFF03DAC6); // Teal Accent
  static const _errorColor = Color(0xFFCF6679);

  // Light Theme Colors
  static const _lightSurface = Color(0xFFFAFAFA);
  static const _lightBackground = Color(0xFFFFFFFF);
  static const _lightTextPrimary = Color(0xFF121212);
  static const _lightTextSecondary = Color(0xFF5f6368);

  // Dark Theme Colors
  static const _darkSurface = Color(0xFF1E1E2C); // Dark Blue-Grey
  static const _darkBackground = Color(0xFF121218); // Almost Black
  static const _darkTextPrimary = Color(0xFFE0E0E0);
  static const _darkTextSecondary = Color(0xFFA0A0A0);

  static final TextTheme _textTheme = GoogleFonts.outfitTextTheme();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _lightSurface,
        background: _lightBackground,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _lightTextPrimary,
        onBackground: _lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _textTheme.apply(
        bodyColor: _lightTextPrimary,
        displayColor: _lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: _lightTextPrimary),
      ),
      // cardTheme: CardTheme(
      //   color: _lightSurface,
      //   elevation: 2,
      //   shadowColor: Colors.black12,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _darkSurface,
        background: _darkBackground,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _darkTextPrimary,
        onBackground: _darkTextPrimary,
        onError: Colors.black,
      ),
      textTheme: _textTheme.apply(
        bodyColor: _darkTextPrimary,
        displayColor: _darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: _darkTextPrimary),
      ),
      // cardTheme: CardTheme(
      //   color: _darkSurface,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
