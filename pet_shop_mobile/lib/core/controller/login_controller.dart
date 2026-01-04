import 'package:flutter/material.dart';

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

  /// Get email value
  String get email => emailController.text.trim();

  /// Get password value
  String get password => passwordController.text;

  /// Clean up controller
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
