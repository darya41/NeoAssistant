import '../../../../core/network/api_client.dart';

class DiagnosticService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getAllDiagnostics({
    int page = 1, int limit = 20,
  }) async {
    final response = await ApiClient.getAuth('diagnostics?page=$page&limit=$limit');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> searchDiagnostics({
    required String query,
    int page = 1, int limit = 20,
  }) async {
    final response = await ApiClient.getAuth(
        'diagnostics/search?q=$query&page=$page&limit=$limit'
    );
    return _validateResponse(response);
  }
}