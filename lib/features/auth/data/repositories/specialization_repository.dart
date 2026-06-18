import '../../domain/entities/specialization.dart';
import '../services/specialization_service.dart';

class SpecializationRepository {
  final SpecializationService _service = SpecializationService();

  Future<List<Specialization>> getSpecializations() async {
    try {
      final data = await _service.getSpecializations();
      return (data)
          .map((json) => Specialization.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}