import 'dart:convert';
import '../../domain/entities/calculator.dart';
import '../services/calculator_service.dart';

class CalculatorRepository {
  final CalculatorService _service = CalculatorService();

  Future<List<Calculator>> getCalculators() async {
    try {
      final response = await _service.getCalculators();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] is List ? decoded['data'] : [];
        } else if (decoded is Map && decoded.containsKey('success') && decoded['success'] == true) {
          data = decoded['data'] is List ? decoded['data'] : [];
        } else {
          data = [];
        }

        return data.map((json) => Calculator.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки калькуляторов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  Future<Calculator> getCalculatorById(int id) async {
    try {
      final response = await _service.getCalculatorById(id);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        Map<String, dynamic> data;

        if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'];
        } else if (decoded is Map && decoded.containsKey('success') && decoded['success'] == true) {
          data = decoded['data'];
        } else {
          data = decoded;
        }

        return Calculator.fromJson(data);
      } else {
        throw Exception('Ошибка загрузки калькулятора: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }

  Future<List<Calculator>> searchCalculators(String query) async {
    try {
      final response = await _service.searchCalculators(query);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] is List ? decoded['data'] : [];
        } else {
          data = [];
        }

        return data.map((json) => Calculator.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка поиска калькуляторов');
      }
    } catch (e) {
      throw Exception('Ошибка соединения: $e');
    }
  }
}