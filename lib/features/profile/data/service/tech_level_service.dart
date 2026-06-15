import '../../../../core/network/api_client.dart';

class TechLevelService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getAllTechLevels() async {
    final response = await ApiClient.getAuth('tech-level');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getMyTechLevel() async {
    final response = await ApiClient.getAuth('tech-level/my');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> updateMyTechLevel(int techLevelId) async {
    final response = await ApiClient.putAuth('tech-level/my', {
      'tech_level_id': techLevelId,
    });
    return _validateResponse(response);
  }
}