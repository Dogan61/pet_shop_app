import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/data/repositories/auth_repository.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/auth/models/auth_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(const AuthInitial());
  final AuthRepository repository;

  Future<void> login(LoginRequestModel request) async {
    print('🔵 [AuthCubit] Login started');
    emit(const AuthLoading());
    try {
      final response = await repository.login(request);
      print('🔵 [AuthCubit] Login response received: success=${response.success}, data=${response.data != null}');

      if (response.success && response.data != null) {
        final authData = response.data!;
        print('🔵 [AuthCubit] AuthData: user=${authData.user != null}, token=${authData.token != null}');
        if (authData.user != null && authData.token != null) {
          print('✅ [AuthCubit] Emitting AuthAuthenticated state');
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
          print('✅ [AuthCubit] AuthAuthenticated state emitted');
        } else {
          print('❌ [AuthCubit] Invalid response data - user or token is null');
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        print('❌ [AuthCubit] Login failed: ${response.message}');
        emit(AuthError(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      print('❌ [AuthCubit] Login error: $e');
      print('❌ [AuthCubit] Error type: ${e.runtimeType}');
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
          emit(AuthRegistered(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Registration failed'));
      }
    } catch (e) {
      print('❌ [AuthCubit] Register error: $e');
      print('❌ [AuthCubit] Error type: ${e.runtimeType}');
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
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      print('❌ [AuthCubit] GetCurrentUser error: $e');
      print('❌ [AuthCubit] Error type: ${e.runtimeType}');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(const AuthUnauthenticated());
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
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Google login failed'));
      }
    } catch (e) {
      print('❌ [AuthCubit] Google login error: $e');
      print('❌ [AuthCubit] Error type: ${e.runtimeType}');
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
          emit(AuthAuthenticated(user: authData.user!, token: authData.token!));
        } else {
          emit(const AuthError(message: 'Invalid response data'));
        }
      } else {
        emit(AuthError(message: response.message ?? 'Facebook login failed'));
      }
    } catch (e) {
      print('❌ [AuthCubit] Facebook login error: $e');
      print('❌ [AuthCubit] Error type: ${e.runtimeType}');
      emit(AuthError(message: e.toString()));
    }
  }
}
