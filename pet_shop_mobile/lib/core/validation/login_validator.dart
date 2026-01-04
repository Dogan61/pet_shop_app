import 'package:flutter/material.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// Login form validations
class LoginValidator {
  /// Email validation
  static String? validateEmail(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.emailCannotBeEmpty;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return l10n?.pleaseEnterValidEmail;
    }

    return null;
  }

  /// Password validation (for login - minimum 6 characters)
  static String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.passwordCannotBeEmpty ?? 'Password cannot be empty';
    }

    if (value.length < 6) {
      return l10n?.passwordMustBeAtLeast6Characters ??
          'Password must be at least 6 characters';
    }

    return null;
  }

  /// Complete login form validation
  static bool validateLoginForm({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    return validateEmail(email, context) == null &&
        validatePassword(password, context) == null;
  }
}
