import '../../../../core/network/api_client.dart';
import '../../domain/entities/protocol.dart';

class ProtocolService {

  Map<String, dynamic> _validateResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }
    return response;
  }

  Future<Map<String, dynamic>> getAllProtocols() async {
    final response = await ApiClient.getAuth('protocols');
    return _validateResponse(response);
  }

  Future<Map<String, dynamic>> getDetailByProtocolId(int protocolId) async {
    final response = await ApiClient.getAuth('protocols/$protocolId');
    return _validateResponse(response);
  }

  Future<List<Protocol>> searchProtocols(String query) async {
    final response = await ApiClient.getAuth('protocols/search?q=$query');

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Ошибка поиска протоколов');
    }

    final data = response['data'];
    if (data is! List) {
      throw Exception('Неверный формат данных');
    }

    return data.map((json) => Protocol.fromJson(json)).toList();
  }
}