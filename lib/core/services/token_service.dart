import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyDisplayName = 'display_name';
  static const _keyPhotoUrl = 'photo_url';

  Future<void> saveAuthData({
    required String token,
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyDisplayName, displayName);
    if (photoUrl != null) {
      await prefs.setString(_keyPhotoUrl, photoUrl);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName);
  }

  Future<String?> getPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoUrl);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyPhotoUrl);
  }
}
