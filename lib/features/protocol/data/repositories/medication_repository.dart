import '../../domain/entities/medication.dart';
import '../services/medication_service.dart';

class MedicationRepository {
  final MedicationService _medicationService = MedicationService();

  Future<List<Medication>> getAllMedications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _medicationService.getAllMedications(page: page, limit: limit);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения списка препаратов');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => Medication.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Medication>> searchMedications(String query) async {
    if (query.isEmpty) {
      return getAllMedications();
    }

    try {
      final response = await _medicationService.searchMedications(query);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка поиска препаратов');
      }

      final data = response['data'];

      if (data is! List) {
        throw Exception('Неверный формат данных: ожидался список');
      }

      return data.map((item) => Medication.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Ошибка поиска: $e');
    }
  }
}