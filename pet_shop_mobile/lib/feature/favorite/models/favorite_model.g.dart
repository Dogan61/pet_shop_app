// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      petId: json['petId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      pet: json['pet'] == null
          ? null
          : PetModel.fromJson(json['pet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'petId': instance.petId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'pet': instance.pet,
    };
