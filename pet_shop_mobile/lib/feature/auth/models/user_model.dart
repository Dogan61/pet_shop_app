import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    this.email,
    this.fullName,
    this.phone,
    this.address,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  @JsonKey(name: 'id')
  final String uid;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? address;
  final String? profileImage;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    String? address,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    fullName,
    phone,
    address,
    profileImage,
    createdAt,
    updatedAt,
  ];
}
