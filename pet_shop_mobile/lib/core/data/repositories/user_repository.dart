import 'package:pet_shop_app/core/data/datasources/user_data_source.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

abstract class UserRepository {
  Future<ApiResponseModel<UserModel>> getProfile(String token);
  Future<ApiResponseModel<UserModel>> updateProfile(
    UserModel user,
    String token,
  );
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.dataSource});
  final UserDataSource dataSource;

  @override
  Future<ApiResponseModel<UserModel>> getProfile(String token) async {
    return dataSource.getProfile(token);
  }

  @override
  Future<ApiResponseModel<UserModel>> updateProfile(
    UserModel user,
    String token,
  ) async {
    return dataSource.updateProfile(user, token);
  }
}
