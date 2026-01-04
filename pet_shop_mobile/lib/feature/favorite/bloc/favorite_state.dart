import 'package:equatable/equatable.dart';
import 'package:pet_shop_app/feature/favorite/models/favorite_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  const FavoriteLoaded({required this.favorites, required this.count});
  final List<FavoriteModel> favorites;
  final int count;

  @override
  List<Object?> get props => [favorites, count];
}

class FavoriteError extends FavoriteState {
  const FavoriteError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class FavoriteAdded extends FavoriteState {
  const FavoriteAdded({required this.favorite});
  final FavoriteModel favorite;

  @override
  List<Object?> get props => [favorite];
}

class FavoriteRemoved extends FavoriteState {
  const FavoriteRemoved();
}
