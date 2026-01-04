import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/favorite/models/favorite_model.dart';

/// Abstract data source interface for favorite-related API operations
abstract class FavoriteDataSource {
  Future<ApiResponseModel<List<FavoriteModel>>> getFavorites(String token);
  Future<ApiResponseModel<FavoriteModel>> addFavorite(
    String petId,
    String token,
  );
  Future<ApiResponseModel<void>> removeFavorite(
    String favoriteId,
    String token,
  );
}

/// Implementation of FavoriteDataSource using Dio for HTTP requests
class FavoriteDataSourceImpl implements FavoriteDataSource {
  FavoriteDataSourceImpl({required this.dio});
  final Dio dio;

  /// Fetches all favorite pets for the authenticated user
  /// [token] - Authentication token for authorization
  /// Returns a list of favorite models wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<List<FavoriteModel>>> getFavorites(
    String token,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.favorites,
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseListResponse<FavoriteModel>(
        response,
        (json) => FavoriteModel.fromJson({...json, 'id': json['id'] ?? ''}),
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

  /// Adds a pet to the user's favorites list
  /// [petId] - The unique identifier of the pet to add to favorites
  /// [token] - Authentication token for authorization
  /// Returns the created favorite model wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<FavoriteModel>> addFavorite(
    String petId,
    String token,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.favorites,
        data: {'petId': petId},
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<FavoriteModel>(
        response,
        (json) => FavoriteModel.fromJson({
          ...(json as Map<String, dynamic>),
          'id': json['id'] ?? '',
        }),
        defaultErrorMessage: 'Failed to add favorite',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(e, defaultMessage: 'Failed to add favorite'),
      );
    }
  }

  /// Removes a pet from the user's favorites list
  /// [favoriteId] - The unique identifier of the favorite entry to remove
  /// [token] - Authentication token for authorization
  /// Returns void wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<void>> removeFavorite(
    String favoriteId,
    String token,
  ) async {
    try {
      final response = await dio.delete<Map<String, dynamic>>(
        ApiEndpoints.favoriteById(favoriteId),
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<void>(
        response,
        (_) {},
        defaultErrorMessage: 'Failed to remove favorite',
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(e, defaultMessage: 'Failed to remove favorite'),
      );
    }
  }
}
