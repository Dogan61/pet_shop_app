import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';

/// Helper class for API operations
class ApiHelper {
  ApiHelper._();

  /// Create authorization header
  static Map<String, String> authHeader(String token) {
    return {ApiHeaders.authorization: ApiHeaders.bearerToken(token)};
  }

  /// Create request options with authorization
  static Options authOptions(String token) {
    return Options(headers: authHeader(token));
  }

  /// Parse API response
  static ApiResponseModel<T> parseResponse<T>(
    Response<dynamic> response,
    T Function(dynamic json) fromJson, {
    String? defaultErrorMessage,
  }) {
    final data = response.data as Map<String, dynamic>;

    if (data[ApiResponseKeys.success] == true) {
      return ApiResponseModel<T>(
        success: true,
        data: data[ApiResponseKeys.data] != null
            ? fromJson(data[ApiResponseKeys.data])
            : null,
        message: data[ApiResponseKeys.message] as String?,
        pagination: data[ApiResponseKeys.pagination] as Map<String, dynamic>?,
        count: data[ApiResponseKeys.count] as int?,
      );
    } else {
      throw Exception(
        (data[ApiResponseKeys.message] as String?) ??
            defaultErrorMessage ??
            ApiErrorMessages.unknownError,
      );
    }
  }

  /// Parse list response
  static ApiResponseModel<List<T>> parseListResponse<T>(
    Response<dynamic> response,
    T Function(Map<String, dynamic> json) fromJson, {
    String? defaultErrorMessage,
  }) {
    final data = response.data as Map<String, dynamic>;

    if (data[ApiResponseKeys.success] == true) {
      final itemsData = data[ApiResponseKeys.data] as List<dynamic>? ?? [];
      final items = itemsData
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();

      return ApiResponseModel<List<T>>(
        success: true,
        data: items,
        pagination: data[ApiResponseKeys.pagination] as Map<String, dynamic>?,
        count: (data[ApiResponseKeys.count] as int?) ?? items.length,
      );
    } else {
      throw Exception(
        (data[ApiResponseKeys.message] as String?) ??
            defaultErrorMessage ??
            ApiErrorMessages.unknownError,
      );
    }
  }

  /// Handle DioException and extract error message
  static String handleError(DioException error, {String? defaultMessage}) {
    if (error.response != null) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final errorMessage = responseData[ApiResponseKeys.message] as String? ??
            defaultMessage ??
            ApiErrorMessages.networkError;
        return errorMessage;
      }
    }
    final finalMessage = defaultMessage ?? ApiErrorMessages.networkError;
    return finalMessage;
  }

  /// Create empty success response (for delete operations)
  static ApiResponseModel<void> emptySuccessResponse() {
    return const ApiResponseModel<void>(success: true);
  }
}
