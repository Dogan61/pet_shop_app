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
  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }

      final googleAuth = await googleUser.authentication;

      // Send ID token to backend
      if (mounted) {
        await context.read<AuthCubit>().loginWithGoogle(googleAuth.idToken!);
      }
    } catch (e) {
      print('❌ [LoginMixin] Google Sign In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign in failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handle Facebook Sign In
  Future<void> handleFacebookSignIn(BuildContext context) async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!;

        // Send access token to backend
        if (mounted) {
          await context.read<AuthCubit>().loginWithFacebook(
            accessToken.tokenString,
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the login
        return;
      } else {
        throw Exception(result.message ?? 'Facebook login failed');
      }
    } catch (e) {
      print('❌ [LoginMixin] Facebook Sign In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facebook sign in failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handle auth state changes
  void handleAuthState(
    BuildContext context,
    AuthState state,
    AppLocalizations? l10n,
  ) {
    print('🔍 [LoginMixin] handleAuthState called with: ${state.runtimeType}');

    if (state is AuthAuthenticated || state is AuthRegistered) {
      print('✅ [LoginMixin] User authenticated, navigating to home...');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state is AuthAuthenticated
                ? (l10n?.loginSuccessful ??
                      LoginConstants.loginSuccessfulFallback)
                : (l10n?.registrationSuccessful ??
                      LoginConstants.registrationSuccessfulFallback),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home after successful login/register
      if (mounted) {
        print('🚀 [LoginMixin] Navigating to ${LoginConstants.homeRoute}');
        try {
          context.go(LoginConstants.homeRoute);
          print('✅ [LoginMixin] Navigation successful');
        } catch (e) {
          print('❌ [LoginMixin] Navigation error: $e');
          // Try alternative navigation method
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(LoginConstants.homeRoute, (route) => false);
        }
      } else {
        print('⚠️ [LoginMixin] Widget not mounted, cannot navigate');
      }
    } else if (state is AuthError) {
      print('❌ [LoginMixin] Auth error: ${state.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
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
