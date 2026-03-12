import 'package:http/http.dart' as http;
import 'dart:convert';

import '../storage/token_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static bool _isRefreshing = false;

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'Ошибка запроса');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  static Future<List<dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Ошибка загрузки');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  static Future<Map<String, dynamic>> postAuth(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (endpoint == 'auth/login' && responseData['success'] == true) {
          await TokenStorage.saveTokens(
            accessToken: responseData['accessToken'],
            refreshToken: responseData['refreshToken'],
            doctorData: responseData['doctor'],
          );
        }
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'Ошибка запроса');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  static Future<bool> refreshToken() async {
    if (_isRefreshing) {
      return false;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        await TokenStorage.saveAccessToken(data['accessToken']);

        if (data['refreshToken'] != null) {
          final doctorData = await TokenStorage.getDoctorData();
          await TokenStorage.saveTokens(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'],
            doctorData: doctorData ?? {},
          );
        }

        return true;
      } else {
        await TokenStorage.clearAll();
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  static Future<Map<String, dynamic>> _sendRequestWithAuth(
      Future<http.Response> Function() request,
      ) async {
    try {
      var response = await request();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }

      if (response.statusCode == 401) {
        final success = await refreshToken();

        if (success) {
          response = await request();
          if (response.statusCode == 200 || response.statusCode == 201) {
            return json.decode(response.body);
          }
        }

        throw Exception('Сессия истекла. Войдите снова.');
      }

      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Ошибка запроса');

    } catch (e) {
      if (e.toString().contains('Сессия истекла')) rethrow;
      throw Exception('Ошибка соединения: $e');
    }
  }
}