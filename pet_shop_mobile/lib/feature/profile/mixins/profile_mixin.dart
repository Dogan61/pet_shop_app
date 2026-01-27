import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/profile/controllers/profile_controller.dart';
import 'package:pet_shop_app/feature/profile/profile_view.dart';

/// Mixin for Profile page logic and lifecycle.
mixin ProfileMixin on State<ProfileView> {
  /// Controller that manages profile-related settings.
  late final ProfileController profileController;

  /// Current index of the bottom navigation bar.
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    profileController = ProfileController();
  }

  @override
  void dispose() {
    profileController.dispose();
    super.dispose();
  }

  /// Creates the bottom navigation tap handler for this view.
  void Function(int) createBottomNavTapHandler(BuildContext context) {
    return BottomNavigationItems.createRouteHandler(
      context,
      setState,
      (index) => currentIndex = index,
    );
  }

  /// Handle auth state changes.
  void handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      // Navigate to login page after logout
      context.go(LoginConstants.loginRoute);
    }
  }

  /// Perform logout action.
  void performLogout(BuildContext context) {
    context.read<AuthCubit>().logout();
  }

  /// Navigate to edit profile (TODO: Implement edit profile page).
  void navigateToEditProfile(BuildContext context) {
    // TODO: Implement edit profile navigation
  }

  /// Handle setting item tap.
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
