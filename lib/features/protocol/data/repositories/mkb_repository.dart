import '../../domain/entities/mkb.dart';
import '../services/mkb_service.dart';

class MkbRepository {
  final MkbService _mkbService = MkbService();

  Future<List<MkbCategory>> getMkbByLevel(int level) async {
    try {
      final response = await _mkbService.getMkbByLevel(level);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения категорий МКБ');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => MkbCategory.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MkbCategory>> getMkbByParentCode(String parentCode) async {
    try {
      final response = await _mkbService.getMkbByParentCode(parentCode);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения дочерних категорий МКБ');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => MkbCategory.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MkbCategory>> getAllMkb({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await _mkbService.getAllMkb(page: page, limit: limit);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения всех категорий МКБ');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => MkbCategory.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MkbCategory>> searchMkb(String query) async {
    if (query.isEmpty) {
      return getAllMkb();
    }

    try {
      final response = await _mkbService.searchMkb(query);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка поиска МКБ');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => MkbCategory.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Ошибка поиска МКБ: $e');
    }
  }

  Future<List<MkbCategory>> getMkbPath(String code) async {
    try {
      final response = await _mkbService.getMkbPath(code);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения пути МКБ');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => MkbCategory.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}