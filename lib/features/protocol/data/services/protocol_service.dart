import '../../../../core/network/api_client.dart';

class ProtocolService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getProtocolFlatListPaginated({ int page = 1, int limit = 20,}) async {
    final response = await ApiClient.getAuth( 'protocols/list?page=$page&limit=$limit');
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
}