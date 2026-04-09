import '../../../../core/network/api_client.dart';

class ProtocolService {

  Future<Map<String, dynamic>> getAllProtocols() async {
    final response = await ApiClient.getAuth('protocols');

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}