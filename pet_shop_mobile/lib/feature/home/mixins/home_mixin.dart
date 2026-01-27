import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/models/pet_category.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/home/controllers/home_controller.dart';
import 'package:pet_shop_app/feature/home/home_view.dart';

/// Mixin for Home page business logic and lifecycle.
mixin HomeMixin on State<HomeView> {
  /// Controller that manages home view state (selected category, favorites loaded flag, etc.).
  late final HomeController homeController;

  /// Current index of the bottom navigation bar.
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    homeController = HomeController();
  }

  @override
  void dispose() {
    homeController.dispose();
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

  /// Loads favorites once when the user is authenticated.
  void loadFavoritesOnceIfAuthenticated(
    BuildContext context,
    AuthState authState,
  ) {
    if (authState is! AuthAuthenticated) return;
    if (homeController.hasLoadedFavorites) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoriteCubit>().getFavorites(authState.token);
      homeController.markFavoritesLoaded();
    });
  }

  /// Returns the currently selected pet category.
  PetCategory get selectedCategory => homeController.selectedCategory;

  /// Sets the current pet category.
  void setCategory(PetCategory category) {
    homeController.setCategory(category);
  }
}
