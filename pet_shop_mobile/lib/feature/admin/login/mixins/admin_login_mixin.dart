import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/validation/login_validator.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_cubit.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_state.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';

/// Mixin for Admin Login logic
mixin AdminLoginMixin<T extends StatefulWidget> on State<T> {
  /// Handle admin state changes
  void handleAdminState(BuildContext context, AdminState state) {
    if (state is AdminChecked) {
      if (state.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AdminConstants.adminLoginSuccess),
            backgroundColor: Colors.green,
          ),
        );
        context.go(AdminConstants.adminDashboardRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AdminConstants.accessDenied),
            backgroundColor: Colors.red,
          ),
        );
        context.read<AuthCubit>().logout();
      }
    } else if (state is AdminError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handle auth state changes
  void handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Check admin status after login
      context.read<AdminCubit>().checkAdmin(state.token);
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
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

    if (LoginValidator.validateLoginForm(
      email: email,
      password: password,
      context: context,
    )) {
      context.read<AuthCubit>().login(
            LoginRequestModel(
              email: email,
              password: password,
            ),
          );
    }
  }

  /// Navigate back to user login
  void navigateToUserLogin(BuildContext context) {
    context.go(LoginConstants.loginRoute);
  }
}

