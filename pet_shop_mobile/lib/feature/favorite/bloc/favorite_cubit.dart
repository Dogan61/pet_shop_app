import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/favorite_repository.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required this.repository}) : super(const FavoriteInitial());
  final FavoriteRepository repository;

  Future<void> getFavorites(String token) async {
    emit(const FavoriteLoading());
    try {
      final response = await repository.getFavorites(token);

      if (response.success && response.data != null) {
        emit(
          FavoriteLoaded(
            favorites: response.data!,
            count: response.count ?? response.data!.length,
          ),
        );
      } else {
        emit(
          FavoriteError(
            message: response.message ?? 'Failed to load favorites',
          ),
        );
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> addFavorite(String petId, String token) async {
    emit(const FavoriteLoading());
    try {
      final response = await repository.addFavorite(petId, token);

      if (response.success && response.data != null) {
        emit(FavoriteAdded(favorite: response.data!));
        // Reload favorites
        await getFavorites(token);
      } else {
        emit(
          FavoriteError(message: response.message ?? 'Failed to add favorite'),
        );
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> removeFavorite(String favoriteId, String token) async {
    emit(const FavoriteLoading());
    try {
      final response = await repository.removeFavorite(favoriteId, token);

      if (response.success) {
        emit(const FavoriteRemoved());
        // Reload favorites
        await getFavorites(token);
      } else {
        emit(
          FavoriteError(
            message: response.message ?? 'Failed to remove favorite',
          ),
        );
      }
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  /// Check if a pet is favorited by petId
  bool isFavorite(String petId) {
    final state = this.state;
    if (state is FavoriteLoaded) {
      return state.favorites.any((favorite) => favorite.petId == petId);
    }
    return false;
  }

  /// Get favorite ID by petId
  String? getFavoriteIdByPetId(String petId) {
    final state = this.state;
    if (state is FavoriteLoaded) {
      final favorite = state.favorites.firstWhere(
        (favorite) => favorite.petId == petId,
        orElse: () => throw StateError('Favorite not found'),
      );
      return favorite.id;
    }
    return null;
  }

  /// Toggle favorite by petId (add if not favorited, remove if favorited)
  Future<void> toggleFavoriteByPetId(String petId, String token) async {
    if (isFavorite(petId)) {
      final favoriteId = getFavoriteIdByPetId(petId);
      if (favoriteId != null) {
        await removeFavorite(favoriteId, token);
      }
    } else {
      await addFavorite(petId, token);
    }
  }
}
