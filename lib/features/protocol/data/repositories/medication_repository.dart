import '../../domain/entities/medication.dart';
import '../services/medication_service.dart';

class MedicationRepository {
  final MedicationService _medicationService = MedicationService();

  Future<Map<String, dynamic>> getMedicationsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _medicationService.getAllMedications(page: page, limit: limit);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения списка препаратов');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      final items = data.map((item) => Medication.fromJson(item)).toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMedicationsByDrugClassPaginated({
    required String drugClass,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _medicationService.getMedicationsByDrugClass(
        drugClass: drugClass,
        page: page,
        limit: limit,
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения препаратов по классу');
      }

      final data = response['data'];
      final pagination = response['pagination'] ?? {};

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      final items = data.map((item) => Medication.fromJson(item)).toList();

      return {
        'items': items,
        'hasNext': pagination['hasNext'] ?? false,
        'currentPage': pagination['currentPage'] ?? page,
        'total': pagination['total'] ?? 0,
        'drugClass': drugClass,
      };
    } catch (e) {
      rethrow;
    }
  }
}