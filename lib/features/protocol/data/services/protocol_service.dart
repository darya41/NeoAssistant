import '../../../../core/network/api_client.dart';

class ProtocolService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getProtocolFlatListPaginated({
    int page = 1, int limit = 20, int? techLevelId,
  }) async {
    String url = 'protocols/list?page=$page&limit=$limit';
    if (techLevelId != null) {
      url += '&techLevelId=$techLevelId';
    }
    final response = await ApiClient.getAuth(url);
    return response;
  }

  Future<Map<String, dynamic>> getProtocolHierarchy(int protocolDocumentId) async {
    final response = await ApiClient.getAuth('protocols/$protocolDocumentId/hierarchy');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getProtocolDocumentById(int protocolDocumentId) async {
    final response = await ApiClient.getAuth('protocols/$protocolDocumentId');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getFullBranch(int hierarchyId) async {
    final response = await ApiClient.getAuth('protocols/hierarchy/$hierarchyId/branch');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> searchProtocols({
    required String query,
    int page = 1, int limit = 20, int? techLevelId,
  }) async {
    String url = 'protocols/search?q=$query&page=$page&limit=$limit';
    if (techLevelId != null) {
      url += '&techLevelId=$techLevelId';
    }
    final response = await ApiClient.getAuth(url);
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getProtocolsByMedication({
    required int medicationId,
    int page = 1, int limit = 20, int? techLevelId,
  }) async {
    String url = 'protocols/medication/$medicationId?page=$page&limit=$limit';
    if (techLevelId != null) {
      url += '&techLevelId=$techLevelId';
    }
    final response = await ApiClient.getAuth(url);
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getProtocolsByDiagnostic({
    required int diagnosticId,
    int page = 1, int limit = 20, int? techLevelId,
  }) async {
    String url = 'protocols/diagnostic/$diagnosticId?page=$page&limit=$limit';
    if (techLevelId != null) {
      url += '&techLevelId=$techLevelId';
    }
    final response = await ApiClient.getAuth(url);
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getProtocolsByMkb({
    required int mkbId,
    int page = 1, int limit = 20, int? techLevelId,
  }) async {
    String url = 'protocols/mkb/$mkbId?page=$page&limit=$limit';
    if (techLevelId != null) {
      url += '&techLevelId=$techLevelId';
    }
    final response = await ApiClient.getAuth(url);
    return _validateResponse(response);
  }
}