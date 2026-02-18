import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  // Save auth token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  // Get auth token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  // Get organization ID from token payload
  String? getOrganizationIdFromToken() {
    final token = getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final String decoded = utf8.decode(
        base64.decode(base64.normalize(payload)),
      );
      final Map<String, dynamic> data = json.decode(decoded);
      return data['organization_id']?.toString();
    } catch (e) {
      return null;
    }
  }

  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  // Save user ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  // Get user ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getString(_tokenKey) != null;
  }

  // Clear all auth data (logout)
  Future<void> clearAll() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
  }
}
