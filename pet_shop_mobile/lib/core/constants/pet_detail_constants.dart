import 'package:flutter/material.dart';

/// Constants for Pet Detail feature
class PetDetailConstants {
  PetDetailConstants._();

  // Default Pet Data
  static const String defaultLocation = 'Besiktas, Istanbul';
  static const String defaultOwnerName = 'Elif Yilmaz';
  static const String maleGender = 'Male';
  static const String femaleGender = 'Female';
  static const String goldColor = 'Gold';
  static const String brownColor = 'Brown';

  // Weight Calculation
  static const int baseWeight = 20;
  static const int weightIncrement = 3;

  // Price Calculation
  static const int basePrice = 3000;
  static const int priceIncrement = 500;

  // Description Template
  static const String descriptionTemplate =
      '{name} is an energetic, playful, and loving {breed}. Gets along very well with people and loves playing with children. Fully house-trained and knows basic commands. Loves morning walks and playing ball in the park. Looking for a new home! 🐾';

  // UI Labels
  static const String ownerLabel = 'Pet Owner';
  static const String aboutLabel = 'About';
  static const String healthStatusLabel = 'Health Status';
  static const String adoptionFeeLabel = 'ADOPTION FEE';
  static const String adoptNowButton = 'Adopt Now';

  // Health Status Labels
  static const String allVaccinesComplete = 'All Vaccines Complete';
  static const String neutered = 'Neutered';
  static const String healthRecordAvailable = 'Health Record Available';

  // Info Card Labels
  static const String ageLabel = 'AGE';
  static const String genderLabel = 'GENDER';
  static const String weightLabel = 'WEIGHT';
  static const String colorLabel = 'COLOR';

  // Colors
  static const Color primaryColor = Color(0xFF7BAF7B);
  static const Color successColor = Color(0xFF13EC5B);
  static const Color darkTextColor = Color(0xFF0F172A);
  static const Color lightTextColor = Color(0xFF334155);
  static const Color borderColor = Color(0xFFF1F5F9);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Grey Colors
  static const Color grey = Colors.grey;
  static Color grey300 = Colors.grey[300]!;
  static Color grey700 = Colors.grey[700]!;
  static Color grey200 = Colors.grey[200]!;

  // Info Card Icon Colors
  static const Color ageIconColor = Colors.orange;
  static const Color genderIconColor = Colors.blue;
  static const Color weightIconColor = Colors.purple;

  // Health Status Colors
  static const Color vaccinesColor = Colors.green;
  static const Color neuteredColor = Colors.blue;
  static const Color healthRecordColor = Colors.purple;

  // Shadow Colors
  static const Color shadowColor = Colors.black12;
  static Color gradientOverlayColor = Colors.black.withOpacity(0.6);

  // Bottom Sheet Colors
  static Color bottomSheetBackground = Colors.white.withOpacity(0.9);
  static Color successShadowColor = successColor.withOpacity(0.4);
}
