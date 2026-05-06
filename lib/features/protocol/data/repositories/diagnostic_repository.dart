import '../../domain/entities/diagnostic_test.dart';
import '../services/diagnostic_service.dart';

class DiagnosticRepository {
  final DiagnosticService _diagnosticService = DiagnosticService();

  Future<List<DiagnosticTest>> getAllDiagnostics({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _diagnosticService.getAllDiagnostics(page: page, limit: limit);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения диагностических тестов');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => DiagnosticTest.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DiagnosticTest>> searchDiagnostics(String query) async {
    if (query.isEmpty) {
      return getAllDiagnostics();
    }

    try {
      final response = await _diagnosticService.searchDiagnostics(query);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка поиска диагностических тестов');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => DiagnosticTest.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Ошибка поиска: $e');
    }
  }
}