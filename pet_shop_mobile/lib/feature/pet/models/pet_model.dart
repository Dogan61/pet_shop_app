import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pet_model.g.dart';

@JsonSerializable()
class PetModel extends Equatable {
  const PetModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.weight,
    required this.color,
    required this.location,
    required this.distance,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.owner,
    this.healthStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);
  final String id;
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String weight;
  final String color;
  final String location;
  final String distance;
  @JsonKey(fromJson: _priceFromJson)
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final PetOwnerModel? owner;
  final PetHealthStatusModel? healthStatus;
  @JsonKey(name: 'createdAt', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$PetModelToJson(this);

  /// Helper function to safely convert price from JSON
  /// Handles both string and numeric values
  static double _priceFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0;
  }

  /// Helper function to safely convert DateTime from JSON
  /// Handles ISO strings, Firestore timestamp objects, and null values
  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value == null) return null;

    // If it's already a DateTime, return it
    if (value is DateTime) return value;

    // If it's a string (ISO format), parse it
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }

    // If it's a Firestore timestamp object with _seconds
    if (value is Map<String, dynamic>) {
      if (value.containsKey('_seconds')) {
        final seconds = value['_seconds'] as int?;
        if (seconds != null) {
          final milliseconds = value['_nanoseconds'] != null
              ? (value['_nanoseconds'] as int) ~/ 1000000
              : 0;
          return DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000 + milliseconds,
            isUtc: true,
          );
        }
      }
    }

    return null;
  }

  PetModel copyWith({
    String? id,
    String? name,
    String? breed,
    String? age,
    String? gender,
    String? weight,
    String? color,
    String? location,
    String? distance,
    double? price,
    String? imageUrl,
    String? description,
    String? category,
    PetOwnerModel? owner,
    PetHealthStatusModel? healthStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      owner: owner ?? this.owner,
      healthStatus: healthStatus ?? this.healthStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    age,
    gender,
    weight,
    color,
    location,
    distance,
    price,
    imageUrl,
    description,
    category,
    owner,
    healthStatus,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class PetOwnerModel extends Equatable {
  const PetOwnerModel({required this.name, this.imageUrl});

  factory PetOwnerModel.fromJson(Map<String, dynamic> json) =>
      _$PetOwnerModelFromJson(json);
  final String name;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$PetOwnerModelToJson(this);

  @override
  List<Object?> get props => [name, imageUrl];
}

@JsonSerializable()
class PetHealthStatusModel extends Equatable {
  const PetHealthStatusModel({
    required this.vaccines,
    required this.neutered,
    required this.healthRecord,
  });

  factory PetHealthStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PetHealthStatusModelFromJson(json);
  final bool vaccines;
  final bool neutered;
  final bool healthRecord;

  Map<String, dynamic> toJson() => _$PetHealthStatusModelToJson(this);

  @override
  List<Object?> get props => [vaccines, neutered, healthRecord];
}
