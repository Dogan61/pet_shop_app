import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/validation/login_validator.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// Register form validations
class RegisterValidator {
  /// First name validation
  static String? validateFirstName(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.firstNameCannotBeEmpty;
    }

    if (value.length < 2) {
      return l10n?.firstNameMustBeAtLeast2Characters;
    }

    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value)) {
      return l10n?.firstNameCanOnlyContainLetters;
    }

    return null;
  }

  /// Last name validation
  static String? validateLastName(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.lastNameCannotBeEmpty;
    }
    if (value.length < 2) {
      return l10n?.lastNameMustBeAtLeast2Characters;
    }
    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value)) {
      return l10n?.lastNameCanOnlyContainLetters;
    }
    return null;
  }

  /// Email validation (uses LoginValidator)
  static String? validateEmail(String? value, BuildContext context) {
    return LoginValidator.validateEmail(value, context);
  }

  /// Password validation (for register - minimum 8 characters + complex)
  static String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.passwordCannotBeEmpty;
    }

    if (value.length < 8) {
      return l10n?.passwordMustBeAtLeast8Characters;
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return l10n?.passwordMustContainUppercaseLowercaseAndDigit;
    }

    return null;
  }

  /// Complete register form validation
  static bool validateRegisterForm({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) {
    return validateFirstName(firstName, context) == null &&
        validateLastName(lastName, context) == null &&
        validateEmail(email, context) == null &&
        validatePassword(password, context) == null;
  }
}
