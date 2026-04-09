import '../../domain/entities/protocol.dart';
import '../services/protocol_service.dart';

class ProtocolRepository {
  final ProtocolService _protocolService = ProtocolService();

  Future<List<Protocol>> getAllProtocols() async {
    try {
      final response = await _protocolService.getAllProtocols();

      if (response['success'] != true) {
        throw Exception(
            response['error'] ?? 'Ошибка получения списка протоколов');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => Protocol.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}