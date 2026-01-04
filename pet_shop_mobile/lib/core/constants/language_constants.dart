import 'package:flutter/material.dart';

/// Constants for language selector and localization
class LanguageConstants {
  LanguageConstants._();

  // Supported Locales
  static const Locale englishLocale = Locale('en');
  static const Locale turkishLocale = Locale('tr');

  // Language Display Names
  static const String englishName = 'English';
  static const String turkishName = 'Türkçe';

  // Language Flag Emojis
  static const String englishFlag = '🇬🇧';
  static const String turkishFlag = '🇹🇷';

  // Supported Locales List
  static const List<Locale> supportedLocales = [englishLocale, turkishLocale];
}
