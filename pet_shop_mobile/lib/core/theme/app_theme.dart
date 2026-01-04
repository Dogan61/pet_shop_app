import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/pet_detail_constants.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LoginConstants.primaryColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: PetDetailConstants.darkTextColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: PetDetailConstants.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
        bodyMedium: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
        bodySmall: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
        labelLarge: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
        labelMedium: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
        labelSmall: TextStyle(
          color: PetDetailConstants.lightTextColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HomeConstants.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PetDetailConstants.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PetDetailConstants.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: LoginConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginConstants.primaryColor,
          foregroundColor: HomeConstants.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LoginConstants.primaryColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: HomeConstants.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LoginConstants.primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
