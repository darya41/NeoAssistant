import '../../../../core/network/api_client.dart';

class MkbService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getMkbByLevel(int level) async {
    final response = await ApiClient.getAuth('mkb/level/$level');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getMkbByParentCode(String parentCode) async {
    final response = await ApiClient.getAuth('mkb/parent/$parentCode');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getAllMkb({
    int page = 1,int limit = 100,
  }) async {
    final response = await ApiClient.getAuth('mkb?page=$page&limit=$limit');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> searchMkb(String query) async {
    final response = await ApiClient.getAuth('mkb/search?q=$query');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getMkbPath(String code) async {
    final response = await ApiClient.getAuth('mkb/path/$code');
    return _validateResponse(response);
  }
}