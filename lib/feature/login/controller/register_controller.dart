import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/validation/register_validator.dart';

/// Business logic controller for register page
class RegisterController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  /// Callback for back button
  VoidCallback onBackPressed(BuildContext context) {
    return () {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/login');
      }
    };
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  /// Perform register operation
  bool handleRegister() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (RegisterValidator.validateRegisterForm(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    )) {
      // TODO: Register operation will be performed here
      return true;
    }

    return false;
  }

  /// Clean up controller
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

