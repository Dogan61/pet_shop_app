import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends Equatable {
  final bool success;
  final String? message;
  final AuthDataModel? data;

  const AuthResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable()
class AuthDataModel extends Equatable {
  final UserModel? user;
  final String? token;

  const AuthDataModel({
    this.user,
    this.token,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataModelToJson(this);

  @override
  List<Object?> get props => [user, token];
}

@JsonSerializable()
class LoginRequestModel extends Equatable {
  final String email;
  final String password;

  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  @override
  List<Object?> get props => [email, password];
}

@JsonSerializable()
class RegisterRequestModel extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);

  @override
  List<Object?> get props => [fullName, email, password];
}

