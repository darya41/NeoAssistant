import 'dart:developer';
import '../services/exam_metadata_service.dart';

class ExamMetadataRepository {
  final ExamMetadataService _service = ExamMetadataService();
  static const String _defaultExamType = 'Осмотр';

  Future<int?> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    try {
      final response = await _service.getPrimaryExamId(
        patientId: patientId,
        examTypeId: examTypeId,
      );

      int? result;

      if (response['patient_exam_id'] != null) {
        result = response['patient_exam_id'] as int?;
      } else if (response['patients_exams_id'] != null) {
        result = response['patients_exams_id'] as int?;
      } else if (response['id'] != null) {
        result = response['id'] as int?;
      }

      return result;

    } catch (e) {
      log('Ошибка получения ID первичного осмотра', error: e, name: 'ExamMetadataRepository');
     return null;
    }
  }

  Future<DateTime?> getExamDateTime(int patientExamId) async {

    try {
      final response = await _service.getExamDateTime(patientExamId);
      String? dateTimeStr = _extractDateTimeString(response);

      if (dateTimeStr == null || dateTimeStr.isEmpty) {
        return null;
      }

      final result = DateTime.parse(dateTimeStr);
      return result;

    } catch (e) {
      log('Ошибка получения даты осмотра', error: e, name: 'ExamMetadataRepository');
      return null;
    }
  }

  Future<String?> getExamTypeByExamId(int patientExamId) async {

    try {
      final response = await _service.getExamTypeByExamId(patientExamId);

      String? examName = _extractExamNameString(response);

      final result = examName?.isNotEmpty == true ? examName : _defaultExamType;
      return result;

    } catch (e) {
      log('Ошибка получения типа осмотра', error: e, name: 'ExamMetadataRepository');
      return _defaultExamType;
    }
  }

  String? _extractDateTimeString(Map<String, dynamic> response) {
    if (response.containsKey('date_time')) {
      final dateTimeField = response['date_time'];

      if (dateTimeField is String) {
        return dateTimeField;
      }

      if (dateTimeField is Map<String, dynamic>) {
        if (dateTimeField.containsKey('date_time')) {
          final nestedDateTime = dateTimeField['date_time'];
          if (nestedDateTime is String) {
            return nestedDateTime;
          }
        }
        if (dateTimeField.containsKey('datetime')) {
          final nestedDateTime = dateTimeField['datetime'];
          if (nestedDateTime is String) {
            return nestedDateTime;
          }
        }
      }
    }

    if (response.containsKey('datetime')) {
      final datetimeField = response['datetime'];
      if (datetimeField is String) {
        return datetimeField;
      }
      if (datetimeField is Map<String, dynamic> && datetimeField.containsKey('datetime')) {
        final nestedDateTime = datetimeField['datetime'];
        if (nestedDateTime is String) {
          return nestedDateTime;
        }
      }
    }

    if (response.containsKey('exam_date')) {
      final examDateField = response['exam_date'];
      if (examDateField is String) {
        return examDateField;
      }
    }

    if (response.containsKey('created_at')) {
      final createdAtField = response['created_at'];
      if (createdAtField is String) {
        return createdAtField;
      }
    }

    return null;
  }

  String? _extractExamNameString(Map<String, dynamic> response) {
    if (response.containsKey('exam_name')) {
      final examNameField = response['exam_name'];

      if (examNameField is String) {
        return examNameField;
      }

      if (examNameField is Map<String, dynamic>) {
        if (examNameField.containsKey('exam_name')) {
          final nestedExamName = examNameField['exam_name'];
          if (nestedExamName is String) {
            return nestedExamName;
          }
        }

        if (examNameField.containsKey('name')) {
          final nestedName = examNameField['name'];
          if (nestedName is String) {
            return nestedName;
          }
        }
      }
    }

    if (response.containsKey('name')) {
      final nameField = response['name'];
      if (nameField is String) {
        return nameField;
      }
    }

    if (response.containsKey('title')) {
      final titleField = response['title'];
      if (titleField is String) {
        return titleField;
      }
    }

    if (response.containsKey('exam_type')) {
      final examTypeField = response['exam_type'];
      if (examTypeField is String) {
        return examTypeField;
      }
    }

    return null;
  }
}