import 'dart:developer';
import '../../domain/entities/mother.dart';
import '../services/mother_service.dart';

class MotherRepository {
  final MotherService _motherService = MotherService();

  Future<Mother> createMother(Mother mother) async {
    try {
      final response = await _motherService.createMother(mother);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка создания матери');
      }

      final motherData = response['data'];

      if (motherData == null) {
        throw Exception('Сервер не вернул данные матери');
      }

      final motherJson = _extractMotherData(motherData);

      if (!motherJson.containsKey('mother_id') && !motherJson.containsKey('id')) {
        throw Exception('Сервер не вернул ID матери');
      }

      return Mother.fromJson(motherJson);
    } catch (e) {
      log('Ошибка при создании матери', error: e, name: 'MotherRepository');
      rethrow;
    }
  }

  Future<List<Mother>> getAllMothers() async {
    try {
      final response = await _motherService.getAllMothers();

      if (response['success'] != true) {
        log('API вернул success=false: ${response['error']}', name: 'MotherRepository');
        return [];
      }

      final mothersData = response['data'];

      if (mothersData == null) {
        return [];
      }

      return _extractMotherList(mothersData);
    } catch (e) {
      log('Ошибка при получении списка матерей', error: e, name: 'MotherRepository');
      return [];
    }
  }

  Future<Mother> getMotherById(int id) async {
    try {
      log('MotherRepository.getMotherById: $id', name: 'MotherRepository');

      final response = await _motherService.getMotherById(id);

      log('Ответ сервера получен', name: 'MotherRepository');

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка загрузки матери');
      }

      final motherData = response['data'];

      if (motherData == null) {
        throw Exception('Мать не найдена');
      }

      final motherJson = _extractMotherData(motherData);
      final mother = Mother.fromJson(motherJson);

      log('Мать загружена: ID=${mother.id}, ФИО=${mother.fullName}', name: 'MotherRepository');
      return mother;
    } catch (e) {
      log('Ошибка в MotherRepository.getMotherById', error: e, name: 'MotherRepository');
      rethrow;
    }
  }

  Map<String, dynamic> _extractMotherData(dynamic motherData) {
    if (motherData is List) {
      if (motherData.isEmpty) {
        throw Exception('Сервер вернул пустой список');
      }
      if (motherData[0] is! Map<String, dynamic>) {
        throw Exception('Неверный формат данных в списке');
      }
      return motherData[0];
    } else if (motherData is Map<String, dynamic>) {
      return motherData;
    } else {
      throw Exception('Неверный тип данных: ${motherData.runtimeType}');
    }
  }

  List<Mother> _extractMotherList(dynamic mothersData) {
    final List<Mother> mothers = [];

    if (mothersData is List) {
      for (var item in mothersData) {
        if (item is Map<String, dynamic>) {
          mothers.add(Mother.fromJson(item));
        }
      }
    } else if (mothersData is Map<String, dynamic>) {
      mothers.add(Mother.fromJson(mothersData));
    }

    return mothers;
  }
}