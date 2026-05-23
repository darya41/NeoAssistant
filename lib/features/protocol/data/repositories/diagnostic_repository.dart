import '../../domain/entities/diagnostic_test.dart';
import '../services/diagnostic_service.dart';

class DiagnosticRepository {
  final DiagnosticService _diagnosticService = DiagnosticService();

  Future<Map<String, dynamic>> getDiagnosticsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _diagnosticService.getAllDiagnostics(page: page, limit: limit);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения диагностических тестов');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      final items = data.map((item) => DiagnosticTest.fromJson(item)).toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
  }
}