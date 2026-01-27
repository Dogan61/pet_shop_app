import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';
import 'package:pet_shop_app/feature/favorite/controllers/favorites_controller.dart';
import 'package:pet_shop_app/feature/favorite/views/favorites_view.dart';

/// Mixin to separate business logic from UI on the Favorites page.
mixin FavoritesMixin on State<FavoritesView> {
  /// Checks whether the user is authenticated.
  bool isUserAuthenticated(AuthState state) {
    return state is AuthAuthenticated || state is AuthRegistered;
  }

  /// Extracts the auth token from [AuthState].
  String? extractToken(AuthState state) {
    if (state is AuthAuthenticated) {
      return state.token;
    }
    if (state is AuthRegistered) {
      return state.token;
    }
    return null;
  }

  /// Loads the favorites list only once.
  void loadFavoritesOnce({
    required BuildContext context,
    required FavoritesController controller,
    required String token,
  }) {
    if (controller.hasLoadedFavorites) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoriteCubit>().getFavorites(token);
      controller.markFavoritesLoaded();
    });
  }

  /// Shows a SnackBar when a favorite-related error occurs.
  void handleFavoriteError(
    BuildContext context,
    FavoriteError state,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

