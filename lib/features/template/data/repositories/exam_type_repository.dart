import '../../domain/entities/exam_type.dart';
import '../services/exam_type_service.dart';

class ExamTypeRepository {
  final ExamTypeService _examTypeService = ExamTypeService();

  Future<List<ExamType>> getAllExamTypes() async {
    try {
      final response = await _examTypeService.getAllExamTypes();

      if (response['success'] != true) {
        return [];
      }

      final examTypesData = response['data'];

      if (examTypesData == null) {
        return [];
      }

      return _extractExamTypeList(examTypesData);
    } catch (e) {
      return [];
    }
  }

  List<ExamType> _extractExamTypeList(dynamic examTypesData) {
    final List<ExamType> examTypes = [];

    if (examTypesData is List) {
      for (var item in examTypesData) {
        if (item is Map<String, dynamic>) {
          examTypes.add(ExamType.fromJson(item));
        }
      }
    } else if (examTypesData is Map<String, dynamic>) {
      examTypes.add(ExamType.fromJson(examTypesData));
    }

    return examTypes;
  }
}