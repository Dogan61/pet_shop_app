import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/user_repository.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';
import 'package:pet_shop_app/feature/user/bloc/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(const UserInitial());

  Future<void> getProfile(String token) async {
    emit(const UserLoading());
    try {
      final response = await repository.getProfile(token);

      if (response.success && response.data != null) {
        emit(UserLoaded(user: response.data!));
      } else {
        emit(UserError(message: response.message ?? 'Failed to load profile'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> updateProfile(UserModel user, String token) async {
    emit(const UserLoading());
    try {
      final response = await repository.updateProfile(user, token);

      if (response.success && response.data != null) {
        emit(UserUpdated(user: response.data!));
      } else {
        emit(UserError(message: response.message ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}

