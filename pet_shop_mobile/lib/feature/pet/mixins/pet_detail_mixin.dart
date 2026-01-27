import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/views/pet_detail_view.dart';

/// Mixin that contains data loading and favorites logic for the Pet Detail page.
mixin PetDetailMixin on State<PetDetailView> {
  /// Extracts the auth token from [AuthState].
  String? extractToken(AuthState state) {
    if (state is AuthAuthenticated) {
      return state.token;
    }
    return null;
  }

  /// Loads pet details and favorites only once.
  void loadPetDetailAndFavoritesOnce({
    required BuildContext context,
    required String petId,
    required bool hasLoadedData,
    required VoidCallback markLoaded,
  }) {
    if (hasLoadedData) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Load pet details
      context.read<PetCubit>().getPetById(petId);

      // If the user is authenticated, load favorites
      final authState = context.read<AuthCubit>().state;
      final token = extractToken(authState);
      if (token != null) {
        context.read<FavoriteCubit>().getFavorites(token);
      }

      markLoaded();
    });
  }
}

