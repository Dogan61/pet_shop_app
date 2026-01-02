import 'package:pet_shop_app/core/validation/login_validator.dart';

/// Register form validations
class RegisterValidator {
  /// First name validation
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name cannot be empty';
    }

    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value)) {
      return 'First name can only contain letters';
    }

    return null;
  }

  /// Last name validation
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name cannot be empty';
    }

    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value)) {
      return 'Last name can only contain letters';
    }

    return null;
  }

  /// Email validation (uses LoginValidator)
  static String? validateEmail(String? value) {
    return LoginValidator.validateEmail(value);
  }

  /// Password validation (for register - minimum 8 characters + complex)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }

    return null;
  }

  /// Complete register form validation
  static bool validateRegisterForm({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return validateFirstName(firstName) == null &&
        validateLastName(lastName) == null &&
        validateEmail(email) == null &&
        validatePassword(password) == null;
  }
}

