import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

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
}