import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pet_shop_app/feature/pet_detail/models/pet_model.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel extends Equatable {
  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.petId,
    this.createdAt,
    this.pet,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);
  final String id;
  final String userId;
  final String petId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'pet')
  final PetModel? pet;

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? petId,
    DateTime? createdAt,
    PetModel? pet,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      petId: petId ?? this.petId,
      createdAt: createdAt ?? this.createdAt,
      pet: pet ?? this.pet,
    );
  }

  @override
  List<Object?> get props => [id, userId, petId, createdAt, pet];
}
