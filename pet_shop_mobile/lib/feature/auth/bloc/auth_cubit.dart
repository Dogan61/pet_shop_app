import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/auth_repository.dart';
import 'package:pet_shop_app/core/storage/token_storage.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(const AuthInitial()) {
    _checkAuthStatus();
  }
  final AuthRepository repository;

  /// Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      // Token exists, verify it by getting current user
      await getCurrentUser(token);
    } else {
      // No token, user is not authenticated
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(LoginRequestModel request) async {
    emit(const AuthLoading());
    try {
      final response = await repository.login(request);

      if (response.success && response.data != null) {
        final authData = response.data!;
        if (authData.user != null && authData.token != null) {
          // Save token to storage
          await TokenStorage.saveToken(authData.token!);
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> register(RegisterRequestModel request) async {
    emit(const AuthLoading());
    try {
      final response = await repository.register(request);

      if (response.success && response.data != null) {
        final authData = response.data!;
        if (authData.user != null && authData.token != null) {
          // Save token to storage
          await TokenStorage.saveToken(authData.token!);
          emit(AuthRegistered(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> getCurrentUser(String token) async {
    emit(const AuthLoading());
    try {
      final response = await repository.getCurrentUser(token);

      if (response.success && response.data != null) {
        emit(AuthAuthenticated(user: response.data!, token: token));
      } else {
        // Token is invalid, remove it
        await TokenStorage.removeToken();
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // Token is invalid, remove it
      await TokenStorage.removeToken();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    await repository.logout();
    // Remove token from storage
    await TokenStorage.removeToken();
    if (!isClosed) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Login with Google ID token
  /// [idToken] - Google ID token from Google Sign In
  Future<void> loginWithGoogle(String idToken) async {
    emit(const AuthLoading());
    try {
      final response = await repository.loginWithGoogle(idToken);

      if (response.success && response.data != null) {
        final authData = response.data!;
        if (authData.user != null && authData.token != null) {
          // Save token to storage
          await TokenStorage.saveToken(authData.token!);
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Google login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Login with Facebook access token
  /// [accessToken] - Facebook access token from Facebook Auth
  Future<void> loginWithFacebook(String accessToken) async {
    emit(const AuthLoading());
    try {
      final response = await repository.loginWithFacebook(accessToken);

      if (response.success && response.data != null) {
        final authData = response.data!;
        if (authData.user != null && authData.token != null) {
          // Save token to storage
          await TokenStorage.saveToken(authData.token!);
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Facebook login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
