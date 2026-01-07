import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/admin_repository.dart';
import 'package:pet_shop_app/feature/admin/bloc/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit({required this.repository}) : super(const AdminInitial());
  final AdminRepository repository;

  Future<void> checkAdmin(String token) async {
    emit(const AdminLoading());
    try {
      final response = await repository.checkAdmin(token);

      if (response.success && response.data != null) {
        final isAdmin =
            response.data!['isAdmin'] as bool? ??
            response.data!['admin'] as bool? ??
            false;
        emit(AdminChecked(isAdmin: isAdmin));
      } else {
        emit(AdminError(message: response.message ?? 'Failed to check admin'));
      }
    } catch (e) {
      emit(AdminError(message: e.toString()));
    }
  }
}
