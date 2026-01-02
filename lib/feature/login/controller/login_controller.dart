import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/validation/login_validator.dart';

/// Business logic controller for login page
class LoginController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  /// Perform login operation
  bool handleLogin() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (LoginValidator.validateLoginForm(
      email: email,
      password: password,
    )) {
      // TODO: Login operation will be performed here
      return true;
    }

    return false;
  }

  /// Clean up controller
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

