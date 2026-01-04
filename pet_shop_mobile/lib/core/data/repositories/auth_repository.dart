import 'package:pet_shop_app/core/data/datasources/auth_data_source.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResponseModel<AuthDataModel>> login(LoginRequestModel request);
  Future<ApiResponseModel<AuthDataModel>> register(
    RegisterRequestModel request,
  );
  Future<ApiResponseModel<AuthDataModel>> loginWithGoogle(String idToken);
  Future<ApiResponseModel<AuthDataModel>> loginWithFacebook(String accessToken);
  Future<ApiResponseModel<UserModel>> getCurrentUser(String token);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});
  final AuthDataSource dataSource;

  @override
  Future<ApiResponseModel<AuthDataModel>> login(
    LoginRequestModel request,
  ) async {
    return dataSource.login(request);
  }

  @override
  Future<ApiResponseModel<AuthDataModel>> register(
    RegisterRequestModel request,
  ) async {
    return dataSource.register(request);
  }

  @override
  Future<ApiResponseModel<UserModel>> getCurrentUser(String token) async {
    return dataSource.getCurrentUser(token);
  }

  @override
  Future<ApiResponseModel<AuthDataModel>> loginWithGoogle(String idToken) async {
    return dataSource.loginWithGoogle(idToken);
  }

  @override
  Future<ApiResponseModel<AuthDataModel>> loginWithFacebook(
    String accessToken,
  ) async {
    return dataSource.loginWithFacebook(accessToken);
  }

  @override
  Future<void> logout() async {
    return dataSource.logout();
  }
}
