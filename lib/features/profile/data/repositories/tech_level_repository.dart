import '../../../protocol/domain/entities/tech_level.dart';
import '../service/tech_level_service.dart';

class TechLevelRepository {
  final TechLevelService _service = TechLevelService();

  Future<List<TechLevel>> getAllTechLevels() async {
    try {
      final response = await _service.getAllTechLevels();

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения уровней');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((json) => TechLevel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<TechLevel?> getMyTechLevel() async {
    try {
      final response = await _service.getMyTechLevel();

      if (response['success'] != true) {
        return null;
      }

      final data = response['data'];
      if (data == null) return null;

      final techLevelId = data['tech_level_id'];
      if (techLevelId == null) return null;

      final techLevel = TechLevel(
        id: techLevelId is int ? techLevelId : int.parse(techLevelId.toString()),
        name: data['tech_level_name']?.toString() ?? '',
        priority: data['priority'] is int ? data['priority'] : 0,
      );
      return techLevel;
    } catch (e) {
      return null;
    }
  }


  Future<bool> updateMyTechLevel(int techLevelId) async {
    try {
      final response = await _service.updateMyTechLevel(techLevelId);
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}