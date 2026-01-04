import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';

/// Abstract data source interface for admin-related API operations
abstract class AdminDataSource {
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(String token);
  Future<ApiResponseModel<Map<String, dynamic>>> setAdmin(
    String email,
    String token,
  );
  Future<ApiResponseModel<Map<String, dynamic>>> removeAdmin(
    String email,
    String token,
  );
  Future<ApiResponseModel<List<Map<String, dynamic>>>> getAdmins(String token);
}

/// Implementation of AdminDataSource using Dio for HTTP requests
class AdminDataSourceImpl implements AdminDataSource {
  AdminDataSourceImpl({required this.dio});
  final Dio dio;

  /// Checks if the current user is an admin
  /// [token] - Authentication token for authorization
  /// Returns admin status wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(
    String token,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.adminCheck,
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<Map<String, dynamic>>(
        response,
        (json) => json as Map<String, dynamic>,
        defaultErrorMessage: 'Failed to check admin status',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: 'Failed to check admin status',
        ),
      );
    }
  }

  /// Sets a user as admin
  /// [email] - Email of the user to make admin
  /// [token] - Authentication token for authorization (must be admin)
  /// Returns success message wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<Map<String, dynamic>>> setAdmin(
    String email,
    String token,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.adminSetAdmin,
        data: {'email': email},
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<Map<String, dynamic>>(
        response,
        (json) => json as Map<String, dynamic>,
        defaultErrorMessage: 'Failed to set admin',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(e, defaultMessage: 'Failed to set admin'),
      );
    }
  }

  /// Removes admin role from a user
  /// [email] - Email of the user to remove admin role
  /// [token] - Authentication token for authorization (must be admin)
  /// Returns success message wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<Map<String, dynamic>>> removeAdmin(
    String email,
    String token,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.adminRemoveAdmin,
        data: {'email': email},
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<Map<String, dynamic>>(
        response,
        (json) => json as Map<String, dynamic>,
        defaultErrorMessage: 'Failed to remove admin',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(e, defaultMessage: 'Failed to remove admin'),
      );
    }
  }

  /// Gets all admin users
  /// [token] - Authentication token for authorization (must be admin)
  /// Returns list of admins wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<List<Map<String, dynamic>>>> getAdmins(
    String token,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.adminAdmins,
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseListResponse<Map<String, dynamic>>(
        response,
        (json) => json,
        defaultErrorMessage: 'Failed to get admins',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(e, defaultMessage: 'Failed to get admins'),
      );
    }
  }
}
