import 'package:equatable/equatable.dart';
import 'package:pet_shop_app/feature/auth/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.user,
    required this.token,
    this.isAdmin = false,
  });
  final UserModel user;
  final String token;
  final bool isAdmin;

  @override
  List<Object?> get props => [user, token, isAdmin];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class AuthRegistered extends AuthState {
  const AuthRegistered({required this.user, required this.token});
  final UserModel user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
