// lib/protocol/data/services/diagnostic_service.dart
import '../../../../core/network/api_client.dart';
import '../../domain/entities/diagnostic_test.dart';

class DiagnosticService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getAllDiagnostics({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await ApiClient.getAuth('diagnostics?page=$page&limit=$limit');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> searchDiagnostics(String query) async {
    final response = await ApiClient.getAuth('diagnostics/search?q=$query');
    return _validateResponse(response);
  }
}