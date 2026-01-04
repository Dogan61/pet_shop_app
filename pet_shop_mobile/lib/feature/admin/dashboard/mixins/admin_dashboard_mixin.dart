import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';

/// Mixin for Admin Dashboard logic
mixin AdminDashboardMixin<T extends StatefulWidget> on State<T> {
  /// Handle auth state changes
  void handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      context.go(LoginConstants.loginRoute);
    }
  }

  /// Handle logout
  void handleLogout(BuildContext context) {
    context.read<AuthCubit>().logout();
  }

  /// Navigate to pets list
  void navigateToPets(BuildContext context) {
    context.go(AdminConstants.adminPetsRoute);
  }

  /// Navigate to add pet
  void navigateToAddPet(BuildContext context) {
    context.go(AdminConstants.adminPetsAddRoute);
  }

  /// Navigate to users management (TODO)
  void navigateToUsers(BuildContext context) {
    // TODO: Implement users management navigation
  }

  /// Navigate to settings (TODO)
  void navigateToSettings(BuildContext context) {
    // TODO: Implement settings navigation
  }
}

