import 'package:pet_shop_app/core/data/datasources/favorite_data_source.dart';
import 'package:pet_shop_app/core/models/api_response_model.dart';
import 'package:pet_shop_app/feature/favorite/models/favorite_model.dart';

abstract class FavoriteRepository {
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

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl({required this.dataSource});
  final FavoriteDataSource dataSource;

  @override
  Future<ApiResponseModel<List<FavoriteModel>>> getFavorites(
    String token,
  ) async {
    return dataSource.getFavorites(token);
  }

  @override
  Future<ApiResponseModel<FavoriteModel>> addFavorite(
    String petId,
    String token,
  ) async {
    return dataSource.addFavorite(petId, token);
  }

  @override
  Future<ApiResponseModel<void>> removeFavorite(
    String favoriteId,
    String token,
  ) async {
    return dataSource.removeFavorite(favoriteId, token);
  }
}
