import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _doctorDataKey = 'doctor_data';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> doctorData,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _doctorDataKey, value: json.encode(doctorData));
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<Map<String, dynamic>?> getDoctorData() async {
    final data = await _storage.read(key: _doctorDataKey);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}