import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/pet_repository.dart';
import 'package:pet_shop_app/feature/pet/models/pet_model.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository repository;

  PetCubit({required this.repository}) : super(const PetInitial());

  Future<void> getAllPets({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    emit(const PetLoading());
    try {
      final response = await repository.getAllPets(
        category: category,
        page: page,
        limit: limit,
      );

      if (response.success && response.data != null) {
        emit(PetLoaded(
          pets: response.data!,
          totalCount: response.pagination?['total'] as int?,
          currentPage: response.pagination?['page'] as int?,
          totalPages: response.pagination?['pages'] as int?,
        ));
      } else {
        emit(PetError(message: response.message ?? 'Failed to load pets'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> getPetById(String id) async {
    emit(const PetLoading());
    try {
      final response = await repository.getPetById(id);

      if (response.success && response.data != null) {
        emit(PetDetailLoaded(pet: response.data!));
      } else {
        emit(PetError(message: response.message ?? 'Failed to load pet'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> getPetsByCategory(String category) async {
    emit(const PetLoading());
    try {
      final response = await repository.getPetsByCategory(category);

      if (response.success && response.data != null) {
        emit(PetLoaded(pets: response.data!));
      } else {
        emit(PetError(message: response.message ?? 'Failed to load pets'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> createPet(PetModel pet, String token) async {
    emit(const PetLoading());
    try {
      final response = await repository.createPet(pet, token);

      if (response.success && response.data != null) {
        emit(PetCreated(pet: response.data!));
      } else {
        emit(PetError(message: response.message ?? 'Failed to create pet'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> updatePet(String id, PetModel pet, String token) async {
    emit(const PetLoading());
    try {
      final response = await repository.updatePet(id, pet, token);

      if (response.success && response.data != null) {
        emit(PetUpdated(pet: response.data!));
      } else {
        emit(PetError(message: response.message ?? 'Failed to update pet'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  Future<void> deletePet(String id, String token) async {
    emit(const PetLoading());
    try {
      final response = await repository.deletePet(id, token);

      if (response.success) {
        emit(const PetDeleted());
      } else {
        emit(PetError(message: response.message ?? 'Failed to delete pet'));
      }
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }
}

