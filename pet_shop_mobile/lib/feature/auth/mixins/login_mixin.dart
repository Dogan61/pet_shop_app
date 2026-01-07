import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// Mixin for Login page logic
mixin LoginMixin<T extends StatefulWidget> on State<T> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Handle Google Sign In
  /// Returns error message if failed, null if successful
  Future<String?> handleGoogleSignIn(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled
      }

      final googleAuth = await googleUser.authentication;

      if (mounted && googleAuth.idToken != null) {
        await context.read<AuthCubit>().loginWithGoogle(googleAuth.idToken!);
        return null; // Success
      }
      return 'Failed to get Google ID token';
    } catch (e) {
      return 'Google sign in failed: $e';
    }
  }

  /// Handle Facebook Sign In
  /// Returns error message if failed, null if successful
  Future<String?> handleFacebookSignIn(BuildContext context) async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!;

        if (mounted) {
          await context.read<AuthCubit>().loginWithFacebook(
            accessToken.tokenString,
          );
          return null; // Success
        }
        return 'Widget not mounted';
      } else if (result.status == LoginStatus.cancelled) {
        return null; // User cancelled
      } else {
        return result.message ?? 'Facebook login failed';
      }
    } catch (e) {
      return 'Facebook sign in failed: $e';
    }
  }

  /// Get success message for auth state
  /// Returns message if state is success, null otherwise
  String? getAuthSuccessMessage(AuthState state, AppLocalizations? l10n) {
    if (state is AuthAuthenticated) {
      return l10n?.loginSuccessful ?? LoginConstants.loginSuccessfulFallback;
    } else if (state is AuthRegistered) {
      return l10n?.registrationSuccessful ??
          LoginConstants.registrationSuccessfulFallback;
    }
    return null;
  }

  /// Get error message for auth state
  /// Returns error message if state is error, null otherwise
  String? getAuthErrorMessage(AuthState state) {
    if (state is AuthError) {
      return state.message;
    }
    return null;
  }

  /// Handle login form submission
  void handleLogin(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().login(
      LoginRequestModel(email: email, password: password),
    );
  }

  /// Navigate to register page
  void navigateToRegister(BuildContext context) {
    context.go(LoginConstants.registerRoute);
  }
}
