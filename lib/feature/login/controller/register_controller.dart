import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  /// Get first name value
  String get firstName => firstNameController.text.trim();

  /// Get last name value
  String get lastName => lastNameController.text.trim();

  /// Get email value
  String get email => emailController.text.trim();

  /// Get password value
  String get password => passwordController.text;

  /// Clean up controller
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
