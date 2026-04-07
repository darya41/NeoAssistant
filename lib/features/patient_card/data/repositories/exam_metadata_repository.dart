// data/repositories/exam_metadata_repository.dart
import 'dart:developer';
import '../services/exam_metadata_service.dart';

class ExamMetadataRepository {
  final ExamMetadataService _service = ExamMetadataService();
  static const String _defaultExamType = 'Осмотр';

  /// Получение ID первичного осмотра
  Future<int?> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    try {
      final response = await _service.getPrimaryExamId(
        patientId: patientId,
        examTypeId: examTypeId,
      );

      if (response['success'] != true) return null;

      final data = response['data'];
      return data?['patient_exam_id'] as int?;
    } catch (e) {
      log('Ошибка получения ID первичного осмотра', error: e, name: 'ExamMetadataRepository');
      return null;
    }
  }

  /// Получение даты и времени осмотра
  Future<DateTime?> getExamDateTime(int patientExamId) async {
    try {
      final response = await _service.getExamDateTime(patientExamId);

      if (response['success'] != true) return null;

      final data = response['data'];
      final dateTimeStr = data?['date_time'] as String?;

      if (dateTimeStr == null || dateTimeStr.isEmpty) return null;

      return DateTime.parse(dateTimeStr);
    } catch (e) {
      log('Ошибка получения даты осмотра', error: e, name: 'ExamMetadataRepository');
      return null;
    }
  }

  /// Получение типа осмотра по ID
  Future<String?> getExamTypeByExamId(int patientExamId) async {
    try {
      final response = await _service.getExamTypeByExamId(patientExamId);

      if (response['success'] != true) return _defaultExamType;

      final data = response['data'];
      final examName = data?['exam_name'] as String?;

      return examName?.isNotEmpty == true ? examName : _defaultExamType;
    } catch (e) {
      log('Ошибка получения типа осмотра', error: e, name: 'ExamMetadataRepository');
      return _defaultExamType;
    }
  }
}