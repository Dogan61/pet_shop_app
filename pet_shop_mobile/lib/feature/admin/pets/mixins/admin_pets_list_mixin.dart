import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';

/// Mixin for Admin Pets List logic
mixin AdminPetsListMixin<T extends StatefulWidget> on State<T> {
  /// Show delete confirmation dialog
  void showDeleteDialog(BuildContext context, String petId, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AdminConstants.deletePetTitle),
        content: const Text(AdminConstants.deletePetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AdminConstants.cancelButton),
          ),
          TextButton(
            onPressed: () {
              context.read<PetCubit>().deletePet(petId, token);
              Navigator.pop(context);
            },
            child: const Text(
              AdminConstants.deleteButton,
              style: TextStyle(color: AdminConstants.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle pet state changes
  void handlePetState(BuildContext context, PetState state) {
    if (state is PetDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AdminConstants.petDeletedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      // Reload pets
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<PetCubit>().getAllPets();
      }
    } else if (state is PetError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  /// Navigate to add pet page
  void navigateToAddPet(BuildContext context) {
    context.go(AdminConstants.adminPetsAddRoute);
  }

  /// Navigate to edit pet page
  void navigateToEditPet(BuildContext context, String petId) {
    context.go(AdminConstants.adminPetsEditRoute(petId));
  }

  /// Get auth token
  String getAuthToken(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return authState is AuthAuthenticated ? authState.token : '';
  }
}
