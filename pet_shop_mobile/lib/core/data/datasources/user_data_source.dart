import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

/// Abstract data source interface for user profile-related API operations
abstract class UserDataSource {
  Future<ApiResponseModel<UserModel>> getProfile(String token);
  Future<ApiResponseModel<UserModel>> updateProfile(
    UserModel user,
    String token,
  );
}

/// Implementation of UserDataSource using Dio for HTTP requests
class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl({required this.dio});
  final Dio dio;

  /// Fetches the authenticated user's profile information
  /// [token] - Authentication token for authorization
  /// Returns the user model wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<UserModel>> getProfile(String token) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.userProfile,
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<UserModel>(
        response,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: ApiErrorMessages.failedToFetch,
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: ApiErrorMessages.failedToFetch,
        ),
      );
    }
  }

  /// Updates the authenticated user's profile information
  /// [user] - The updated user model
  /// [token] - Authentication token for authorization
  /// Returns the updated user model wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<UserModel>> updateProfile(
    UserModel user,
    String token,
  ) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        ApiEndpoints.userProfile,
        data: user.toJson(),
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<UserModel>(
        response,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
        defaultErrorMessage: ApiErrorMessages.failedToUpdate,
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: ApiErrorMessages.failedToUpdate,
        ),
      );
    }
  }
}
