import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/models/pet_category.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';
import 'package:pet_shop_app/feature/pet/models/pet_model.dart';

/// Controller for Admin Pet Form
/// Manages form state, validation, and business logic
class AdminPetFormController {
  AdminPetFormController({required this.petId});

  final String? petId;
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final locationController = TextEditingController();
  final distanceController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerImageController = TextEditingController();

  // Form State
  String selectedGender = AdminConstants.genderOptions.first;
  String selectedCategory = PetCategory.dogs.name;
  bool vaccines = false;
  bool neutered = false;
  bool healthRecord = false;

  bool get isEdit => petId != null;

  /// Load pet data into form fields
  void loadPetData(PetModel pet) {
    nameController.text = pet.name;
    breedController.text = pet.breed;
    ageController.text = pet.age;
    weightController.text = pet.weight;
    colorController.text = pet.color;
    locationController.text = pet.location;
    distanceController.text = pet.distance;
    priceController.text = pet.price.toString();
    imageUrlController.text = pet.imageUrl;
    descriptionController.text = pet.description;
    selectedGender = pet.gender;
    selectedCategory = pet.category;
    if (pet.owner != null) {
      ownerNameController.text = pet.owner!.name;
      ownerImageController.text = pet.owner!.imageUrl ?? '';
    }
    if (pet.healthStatus != null) {
      vaccines = pet.healthStatus!.vaccines;
      neutered = pet.healthStatus!.neutered;
      healthRecord = pet.healthStatus!.healthRecord;
    }
  }

  /// Create PetModel from form data
  PetModel buildPetModel() {
    return PetModel(
      id: petId ?? '',
      name: nameController.text.trim(),
      breed: breedController.text.trim(),
      age: ageController.text.trim(),
      gender: selectedGender,
      weight: weightController.text.trim(),
      color: colorController.text.trim(),
      location: locationController.text.trim(),
      distance: distanceController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0.0,
      imageUrl: imageUrlController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      owner: PetOwnerModel(
        name: ownerNameController.text.trim(),
        imageUrl: ownerImageController.text.trim().isEmpty
            ? null
            : ownerImageController.text.trim(),
      ),
      healthStatus: PetHealthStatusModel(
        vaccines: vaccines,
        neutered: neutered,
        healthRecord: healthRecord,
      ),
    );
  }

  /// Validate and submit form
  void submitForm(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AdminConstants.accessDenied),
          backgroundColor: AdminConstants.red,
        ),
      );
      return;
    }

    final pet = buildPetModel();
    final petCubit = context.read<PetCubit>();

    if (isEdit) {
      petCubit.updatePet(petId!, pet, authState.token);
    } else {
      petCubit.createPet(pet, authState.token);
    }
  }

  /// Handle pet state changes
  void handlePetState(BuildContext context, PetState state) {
    if (state is PetDetailLoaded && isEdit) {
      loadPetData(state.pet);
    } else if (state is PetCreated || state is PetUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? AdminConstants.petUpdatedSuccess
                : AdminConstants.petCreatedSuccess,
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AdminConstants.adminPetsRoute);
    } else if (state is PetError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Validation methods
  String? validateRequired(String? value, String errorMessage) {
    return value?.isEmpty ?? true ? errorMessage : null;
  }

  String? validatePrice(String? value) {
    if (value?.isEmpty ?? true) {
      return AdminConstants.priceRequired;
    }
    if (double.tryParse(value!) == null) {
      return AdminConstants.priceInvalid;
    }
    return null;
  }

  /// Dispose all controllers
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    colorController.dispose();
    locationController.dispose();
    distanceController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    ownerNameController.dispose();
    ownerImageController.dispose();
  }
}

