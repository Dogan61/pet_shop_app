import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// Localization configuration for the app
class LocalizationConfig {
  /// Supported locales
  static const List<Locale> supportedLocales = [Locale('en'), Locale('tr')];

  /// Localization delegates
  static const List<LocalizationsDelegate> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
