import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';

/// Abstract data source interface for admin-related API operations
/// Note: Admin role is set manually via Firebase Console - Custom Claims
/// Only one admin is supported. Admin management endpoints are removed.
abstract class AdminDataSource {
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(String token);
}

/// Implementation of AdminDataSource using Dio for HTTP requests
class AdminDataSourceImpl implements AdminDataSource {
  AdminDataSourceImpl({required this.dio});
  final Dio dio;

  /// Checks if the current user is an admin
  /// Admin role is stored in Firestore users collection (isAdmin: true)
  /// [token] - Authentication token for authorization
  /// Returns admin status wrapped in ApiResponseModel
  /// Backend returns: { success: true, isAdmin: bool, data: { uid, email, admin: bool } }
  @override
  Future<ApiResponseModel<Map<String, dynamic>>> checkAdmin(
    String token,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.adminCheck,
        options: ApiHelper.authOptions(token),
      );

      final responseData = response.data!;

      if (responseData['success'] == true) {
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        final rootIsAdmin = responseData['isAdmin'] as bool? ?? false;

        final mergedData = {
          ...data,
          'isAdmin': rootIsAdmin,
          'admin': data['admin'] ?? rootIsAdmin,
        };

        return ApiResponseModel<Map<String, dynamic>>(
          success: true,
          data: mergedData,
          message: responseData['message'] as String?,
        );
      } else {
        throw Exception(
          (responseData['message'] as String?) ??
              'Failed to check admin status',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: 'Failed to check admin status',
        ),
      );
    }
  }
}
