import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';
import 'package:pet_shop_app/feature/favorite/controllers/favorites_controller.dart';
import 'package:pet_shop_app/feature/favorite/views/favorites_view.dart';

/// Mixin to separate business logic from UI on the Favorites page.
mixin FavoritesMixin on State<FavoritesView> {
  /// Controller that manages favorites loading state.
  late final FavoritesController favoritesController;

  /// Current index of the bottom navigation bar.
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    favoritesController = FavoritesController();
  }

  @override
  void dispose() {
    favoritesController.dispose();
    super.dispose();
  }

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
    required String token,
  }) {
    if (favoritesController.hasLoadedFavorites) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoriteCubit>().getFavorites(token);
      favoritesController.markFavoritesLoaded();
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

  /// Creates the bottom navigation tap handler for this view.
  void Function(int) createBottomNavTapHandler(BuildContext context) {
    return BottomNavigationItems.createRouteHandler(
      context,
      setState,
      (index) => currentIndex = index,
    );
  }
}

