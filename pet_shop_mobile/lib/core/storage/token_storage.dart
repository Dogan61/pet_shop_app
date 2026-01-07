import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving authentication token
class TokenStorage {
  static const String _tokenKey = 'auth_token';

  /// Save authentication token
  static Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_tokenKey, token);
  }

  /// Get authentication token
  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  /// Remove authentication token
  static Future<void> removeToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
  }

  /// Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
