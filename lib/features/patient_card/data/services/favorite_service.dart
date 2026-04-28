import '../../../../core/network/api_client.dart';

class FavoriteService {
  Future<Map<String, dynamic>> checkFavorite(int patientId) async {
    final response = await ApiClient.getAuth('favorites/check/$patientId');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> addFavorite(int patientId) async {
    final response = await ApiClient.postAuth('favorites', {
      'patient_id': patientId,
    });

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }

  Future<Map<String, dynamic>> removeFavorite(int patientId) async {
    final response = await ApiClient.deleteAuth('favorites/$patientId');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}