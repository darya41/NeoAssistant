import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';
import '../../../../models/patient.dart';

class PatientService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<List<Patient>> getPatients() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse('$baseUrl/patients'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки пациентов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }
}