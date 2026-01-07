import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/router/app_router.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';

/// Widget that listens to auth state changes and redirects accordingly
class AuthRedirectListener extends StatelessWidget {
  const AuthRedirectListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final currentLocation =
            appRouter.routerDelegate.currentConfiguration.uri.path;

        if (state is AuthAuthenticated || state is AuthRegistered) {
          // User is logged in, redirect to home if on login/register page
          if (currentLocation == '/login' || currentLocation == '/register') {
            appRouter.go('/home');
          }
        } else if (state is AuthUnauthenticated) {
          // User is logged out, redirect to login if not already there
          if (currentLocation != '/login' && currentLocation != '/register') {
            appRouter.go('/login');
          }
        }
      },
      child: child,
    );
  }
}
