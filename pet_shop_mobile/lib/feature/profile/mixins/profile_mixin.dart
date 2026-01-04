import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

/// Mixin for Profile page logic
mixin ProfileMixin<T extends StatefulWidget> on State<T> {
  /// Handle auth state changes
  void handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      // Navigate to login page after logout
      context.go(LoginConstants.loginRoute);
    }
  }

  /// Handle logout with confirmation dialog
  void handleLogout(BuildContext context, AppLocalizations l10n) {
    // Show confirmation dialog
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Perform logout
                context.read<AuthCubit>().logout();
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Navigate to edit profile (TODO: Implement edit profile page)
  void navigateToEditProfile(BuildContext context) {
    // TODO: Implement edit profile navigation
  }

  /// Handle setting item tap
  void handleSettingItemTap(BuildContext context, String setting) {
    // TODO: Implement setting item navigation
    switch (setting) {
      case 'myOrders':
        // Navigate to orders
        break;
      case 'privacyPolicy':
        // Navigate to privacy policy
        break;
      case 'paymentMethods':
        // Navigate to payment methods
        break;
    }
  }
}
