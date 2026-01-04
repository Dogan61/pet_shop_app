import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

/// Abstract data source interface for authentication-related API operations
abstract class AuthDataSource {
  Future<ApiResponseModel<AuthDataModel>> login(LoginRequestModel request);
  Future<ApiResponseModel<AuthDataModel>> register(
    RegisterRequestModel request,
  );
  Future<ApiResponseModel<AuthDataModel>> loginWithGoogle(String idToken);
  Future<ApiResponseModel<AuthDataModel>> loginWithFacebook(String accessToken);
  Future<ApiResponseModel<UserModel>> getCurrentUser(String token);
  Future<void> logout();
}

/// Implementation of AuthDataSource using Dio for HTTP requests
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required this.dio});
  final Dio dio;

  /// Authenticates a user with email and password
  /// [request] - Login request model containing email and password
  /// Returns authentication data (user and token) wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<AuthDataModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final result = ApiHelper.parseResponse<AuthDataModel>(response, (json) {
        try {
          final authData = AuthDataModel.fromJson(json as Map<String, dynamic>);
          return authData;
        } catch (e) {
          rethrow;
        }
      }, defaultErrorMessage: 'Login failed');
      return result;
    } on DioException catch (e) {
      final errorMessage = ApiHelper.handleError(
        e,
        defaultMessage: 'Login failed',
      );
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new user account
  /// [request] - Registration request model containing fullName, email, and password
  /// Returns authentication data (user and token) wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<AuthDataModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      return ApiHelper.parseResponse<AuthDataModel>(
        response,
        (json) => AuthDataModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: 'Registration failed',
      );
    } on DioException catch (e) {
      final errorMessage = ApiHelper.handleError(
        e,
        defaultMessage: 'Registration failed',
      );
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the current authenticated user's profile
  /// [token] - Authentication token for authorization
  /// Returns the user model wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<UserModel>> getCurrentUser(String token) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<UserModel>(
        response,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: 'Failed to get user',
      );
    } on DioException catch (e) {
      final errorMessage = ApiHelper.handleError(
        e,
        defaultMessage: 'Failed to get user',
      );
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Authenticates a user with Google ID token
  /// [idToken] - Google ID token from Google Sign In
  /// Returns authentication data (user and token) wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<AuthDataModel>> loginWithGoogle(
    String idToken,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.loginWithGoogle,
        data: {'idToken': idToken},
      );

      return ApiHelper.parseResponse<AuthDataModel>(
        response,
        (json) => AuthDataModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: 'Google login failed',
      );
    } on DioException catch (e) {
      final errorMessage = ApiHelper.handleError(
        e,
        defaultMessage: 'Google login failed',
      );
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Authenticates a user with Facebook access token
  /// [accessToken] - Facebook access token from Facebook Auth
  /// Returns authentication data (user and token) wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<AuthDataModel>> loginWithFacebook(
    String accessToken,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.loginWithFacebook,
        data: {'accessToken': accessToken},
      );

      return ApiHelper.parseResponse<AuthDataModel>(
        response,
        (json) => AuthDataModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: 'Facebook login failed',
      );
    } on DioException catch (e) {
      final errorMessage = ApiHelper.handleError(
        e,
        defaultMessage: 'Facebook login failed',
      );
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Logs out the current user
  /// Note: Firebase Auth handles logout on client side
  /// Backend logout is optional and not implemented here
  @override
  Future<void> logout() async {
    // Firebase Auth handles logout on client side
    // Backend logout is optional
  }
}
