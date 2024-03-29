import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  final _storage = const FlutterSecureStorage();

  final String _accessToken = "access_token";
  final String _accessTokenExpiration = "access_token_expiration";
  final String _userId = "user_id";

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessToken, value: token);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessToken);
  }

  Future<DateTime?> getAccessTokenExpiration() async {
    final expiration = await _storage.read(key: _accessTokenExpiration);
    if (expiration == null) {
      return null;
    }

    return DateTime.parse(expiration);
  }

  Future<void> saveAccessTokenExpiration(DateTime expiration) async {
    await _storage.write(
        key: _accessTokenExpiration, value: expiration.toIso8601String());
  }

  Future<void> deleteAccessTokenExpiration() async {
    await _storage.delete(key: _accessTokenExpiration);
  }

  Future<String?> getUserId() {
    return _storage.read(key: _userId);
  }

  Future<void> saveUserId(String userId) {
    return _storage.write(key: _userId, value: userId);
  }

  Future<void> deleteUserid() {
    return _storage.delete(key: _userId);
  }
}
