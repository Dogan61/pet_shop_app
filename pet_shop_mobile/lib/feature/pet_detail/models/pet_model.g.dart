// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetModel _$PetModelFromJson(Map<String, dynamic> json) => PetModel(
  id: json['id'] as String,
  name: json['name'] as String,
  breed: json['breed'] as String,
  age: json['age'] as String,
  gender: json['gender'] as String,
  weight: json['weight'] as String,
  color: json['color'] as String,
  location: json['location'] as String,
  distance: json['distance'] as String,
  price: PetModel._priceFromJson(json['price']),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  owner: json['owner'] == null
      ? null
      : PetOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
  healthStatus: json['healthStatus'] == null
      ? null
      : PetHealthStatusModel.fromJson(
          json['healthStatus'] as Map<String, dynamic>,
        ),
  createdAt: PetModel._dateTimeFromJson(json['createdAt']),
  updatedAt: PetModel._dateTimeFromJson(json['updatedAt']),
);

Map<String, dynamic> _$PetModelToJson(PetModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'breed': instance.breed,
  'age': instance.age,
  'gender': instance.gender,
  'weight': instance.weight,
  'color': instance.color,
  'location': instance.location,
  'distance': instance.distance,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'category': instance.category,
  'owner': instance.owner,
  'healthStatus': instance.healthStatus,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

PetOwnerModel _$PetOwnerModelFromJson(Map<String, dynamic> json) =>
    PetOwnerModel(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$PetOwnerModelToJson(PetOwnerModel instance) =>
    <String, dynamic>{'name': instance.name, 'imageUrl': instance.imageUrl};

PetHealthStatusModel _$PetHealthStatusModelFromJson(
  Map<String, dynamic> json,
) => PetHealthStatusModel(
  vaccines: json['vaccines'] as bool,
  neutered: json['neutered'] as bool,
  healthRecord: json['healthRecord'] as bool,
);

Map<String, dynamic> _$PetHealthStatusModelToJson(
  PetHealthStatusModel instance,
) => <String, dynamic>{
  'vaccines': instance.vaccines,
  'neutered': instance.neutered,
  'healthRecord': instance.healthRecord,
};
