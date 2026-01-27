import 'package:dio/dio.dart';
import 'package:pet_shop_app/core/constants/api_constants.dart';
import 'package:pet_shop_app/core/data/helpers/api_helper.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/pet_detail/models/pet_model.dart';

/// Abstract data source interface for pet-related API operations
abstract class PetDataSource {
  Future<ApiResponseModel<List<PetModel>>> getAllPets({
    String? category,
    int page = 1,
    int limit = 10,
  });
  Future<ApiResponseModel<PetModel>> getPetById(String id);
  Future<ApiResponseModel<List<PetModel>>> getPetsByCategory(String category);
  Future<ApiResponseModel<PetModel>> createPet(PetModel pet, String token);
  Future<ApiResponseModel<PetModel>> updatePet(
    String id,
    PetModel pet,
    String token,
  );
  Future<ApiResponseModel<void>> deletePet(String id, String token);
}

/// Implementation of PetDataSource using Dio for HTTP requests
class PetDataSourceImpl implements PetDataSource {
  PetDataSourceImpl({required this.dio});
  final Dio dio;

  /// Fetches all pets with optional category filter and pagination
  /// [category] - Optional category filter (e.g., 'dog', 'cat')
  /// [page] - Page number for pagination (default: 1)
  /// [limit] - Number of items per page (default: 10)
  /// Returns a list of pets wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<List<PetModel>>> getAllPets({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (category != null && category != 'all') {
        queryParams['category'] = category;
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.pets,
        queryParameters: queryParams,
      );

      return ApiHelper.parseListResponse<PetModel>(
        response,
        (json) => PetModel.fromJson({...json, 'id': json['id'] ?? ''}),
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

  /// Fetches a single pet by its ID
  /// [id] - The unique identifier of the pet
  /// Returns the pet wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<PetModel>> getPetById(String id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.petById(id),
      );

      return ApiHelper.parseResponse<PetModel>(
        response,
        (json) => PetModel.fromJson({
          ...(json as Map<String, dynamic>),
          'id': json['id'] ?? id,
        }),
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

  /// Fetches all pets in a specific category
  /// [category] - The category to filter by (e.g., 'dog', 'cat')
  /// Returns a list of pets in the specified category
  @override
  Future<ApiResponseModel<List<PetModel>>> getPetsByCategory(
    String category,
  ) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.petsByCategory(category),
      );

      return ApiHelper.parseListResponse<PetModel>(
        response,
        (json) => PetModel.fromJson({...json, 'id': json['id'] ?? ''}),
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

  /// Creates a new pet (Admin only)
  /// [pet] - The pet model to create
  /// [token] - Authentication token for authorization
  /// Returns the created pet wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<PetModel>> createPet(
    PetModel pet,
    String token,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.pets,
        data: pet.toJson(),
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<PetModel>(
        response,
        (json) => PetModel.fromJson({
          ...(json as Map<String, dynamic>),
          'id': json['id'] ?? '',
        }),
        defaultErrorMessage: ApiErrorMessages.failedToCreate,
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: ApiErrorMessages.failedToCreate,
        ),
      );
    }
  }

  /// Updates an existing pet (Admin only)
  /// [id] - The unique identifier of the pet to update
  /// [pet] - The updated pet model
  /// [token] - Authentication token for authorization
  /// Returns the updated pet wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<PetModel>> updatePet(
    String id,
    PetModel pet,
    String token,
  ) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        ApiEndpoints.petById(id),
        data: pet.toJson(),
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<PetModel>(
        response,
        (json) => PetModel.fromJson({
          ...(json as Map<String, dynamic>),
          'id': json['id'] ?? id,
        }),
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

  /// Deletes a pet by its ID (Admin only)
  /// [id] - The unique identifier of the pet to delete
  /// [token] - Authentication token for authorization
  /// Returns void wrapped in ApiResponseModel
  @override
  Future<ApiResponseModel<void>> deletePet(String id, String token) async {
    try {
      final response = await dio.delete<Map<String, dynamic>>(
        ApiEndpoints.petById(id),
        options: ApiHelper.authOptions(token),
      );

      return ApiHelper.parseResponse<void>(
        response,
        (_) {},
        defaultErrorMessage: ApiErrorMessages.failedToDelete,
      );
    } on DioException catch (e) {
      throw Exception(
        ApiHelper.handleError(
          e,
          defaultMessage: ApiErrorMessages.failedToDelete,
        ),
      );
    }
  }
}
