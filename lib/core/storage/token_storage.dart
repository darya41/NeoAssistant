import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _doctorDataKey = 'doctor_data';
  static const _isGuestKey = 'is_guest_mode';
  static const String _keyTechLevelId = 'tech_level_id';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> doctorData,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _doctorDataKey, value: json.encode(doctorData));
    await _storage.write(key: _isGuestKey, value: 'false');

    if (doctorData['tech_level_id'] != null) {
      await saveTechLevelId(doctorData['tech_level_id']);
    }
  }

  static Future<void> saveGuestMode() async {
    await _storage.write(key: _accessTokenKey, value: 'guest_token');
    await _storage.write(key: _refreshTokenKey, value: 'guest_token');
    await _storage.write(key: _isGuestKey, value: 'true');
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

  static Future<bool> isGuestMode() async {
    final isGuest = await _storage.read(key: _isGuestKey);
    final result = isGuest == 'true';
    return result;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final isGuest = await isGuestMode();
    return token != null && token.isNotEmpty && !isGuest;
  }

  static Future<void> saveDoctorData(Map<String, dynamic> doctorData) async {
    final currentData = await getDoctorData() ?? {};
    final updatedData = {...currentData, ...doctorData};
    await _storage.write(key: _doctorDataKey, value: json.encode(updatedData));

    if (doctorData['tech_level_id'] != null) {
      await saveTechLevelId(doctorData['tech_level_id']);
    }
  }

  static Future<void> saveTechLevelId(int techLevelId) async {
    await _storage.write(key: _keyTechLevelId, value: techLevelId.toString());
  }

  static Future<int?> getTechLevelId() async {
    final value = await _storage.read(key: _keyTechLevelId);
    if (value != null && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }

  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _doctorDataKey);
    await _storage.delete(key: _isGuestKey);
    await _storage.delete(key: _keyTechLevelId);
  }

  static Future<void> clearTechLevelId() async {
    await _storage.delete(key: _keyTechLevelId);
  }
}