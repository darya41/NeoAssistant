import '../../domain/entities/detail_protocol.dart';
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

  Future<DetailProtocol> getByProtocolId(int protocolId) async {
    try {
      final response = await _protocolService.getDetailByProtocolId(protocolId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения деталей протокола');
      }

      final data = response['data'];

      if (data == null) {
        throw Exception('Детали протокола для protocol_id $protocolId не найдены');
      }

      final detailJson = _extractDetailData(data);
      return DetailProtocol.fromJson(detailJson);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _extractDetailData(dynamic data) {
    if (data is List) {
      if (data.isEmpty) {
        throw Exception('Сервер вернул пустой список');
      }
      if (data[0] is! Map<String, dynamic>) {
        throw Exception('Неверный формат данных');
      }
      return data[0];
    } else if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception('Неверный тип data: ${data.runtimeType}');
    }
  }

  Future<List<Protocol>> searchProtocols(String query) async {
    if (query.isEmpty) {
      return getAllProtocols();
    }

    try {
      return await _protocolService.searchProtocols(query);
    } catch (e) {
      throw Exception('Ошибка поиска протоколов: $e');
    }
  }
}