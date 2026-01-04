// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['id'] as String,
  email: json['email'] as String?,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  profileImage: json['profileImage'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.uid,
  'email': instance.email,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'address': instance.address,
  'profileImage': instance.profileImage,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
