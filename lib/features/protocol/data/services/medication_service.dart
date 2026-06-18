import '../../../../core/network/api_client.dart';

class MedicationService {
  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getAllMedications({ int page = 1, int limit = 20,}) async {
    final response = await ApiClient.getAuth('medications?page=$page&limit=$limit');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getMedicationsByDrugClass({
    required String drugClass, int page = 1, int limit = 20,
  }) async {
    final response = await ApiClient.getAuth('medications/class/$drugClass?page=$page&limit=$limit');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> searchMedications({
    required String query, int page = 1, int limit = 20,
  }) async {
    final response = await ApiClient.getAuth('medications/search?q=$query&page=$page&limit=$limit');
    return _validateResponse(response);
  }
}