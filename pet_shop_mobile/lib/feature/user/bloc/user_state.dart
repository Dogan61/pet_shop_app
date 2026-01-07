import 'package:equatable/equatable.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {

  const UserLoaded({required this.user});
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {

  const UserError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class UserUpdated extends UserState {

  const UserUpdated({required this.user});
  final UserModel user;

  @override
  List<Object?> get props => [user];
}
