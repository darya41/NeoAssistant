import '../../../../core/network/api_client.dart';

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
}