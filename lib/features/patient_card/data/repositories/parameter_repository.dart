import '../../../../core/network/api_client.dart';
import '../../domain/entities/medical_parameter.dart';
import '../../domain/entities/medical_parameter_value.dart';

class ParameterRepository {
  static const String _defaultExamType = 'Осмотр';

  Map<String, dynamic> _handleResponse(Map<String, dynamic> response) {
    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Неизвестная ошибка');
    }
    return response;
  }

  Future<List<MedicalParameter>> getParameters(int examId) async {
    try {
      final response = await ApiClient.getAuth('parameters?examId=$examId');
      _handleResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameter.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки параметров: $e');
    }
  }

  Future<int?> getPrimaryExamId({
    required int patientId,
    required int examTypeId,
  }) async {
    try {
      final response = await ApiClient.getAuth(
          'parameters/primary-exam?patientId=$patientId&examTypeId=$examTypeId'
      );

      if (response['success'] != true) return null;

      final data = response['data'];
      return data?['patient_exam_id'] as int?;
    } catch (e) {
      return null;
    }
  }

  Future<List<MedicalParameterValue>> getParametersWithValues({
    required int examId,
    required int patientExamId,
  }) async {
    try {
      final response = await ApiClient.getAuth(
          'parameters/with-values?examId=$examId&patientExamId=$patientExamId'
      );
      _handleResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameterValue(
        name: json['name'] ?? '',
        value: json['value'],
      )).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки параметров со значениями: $e');
    }
  }

  Future<List<MedicalParameterValue>> getParametersWithValuesByExamId({
    required int patientExamId,
  }) async {
    try {
      final response = await ApiClient.getAuth(
          'parameters/values-by-exam-id?patientExamId=$patientExamId'
      );
      _handleResponse(response);

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => MedicalParameterValue(
        name: json['name'] ?? '',
        value: json['value'],
      )).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки параметров по ID осмотра: $e');
    }
  }

  Future<DateTime?> getExamDateTime(int patientExamId) async {
    try {
      final response = await ApiClient.getAuth(
          'parameters/exam-datetime?patientExamId=$patientExamId'
      );

      if (response['success'] != true) return null;

      final data = response['data'];
      final dateTimeStr = data?['date_time'] as String?;

      if (dateTimeStr == null || dateTimeStr.isEmpty) return null;

      return DateTime.parse(dateTimeStr);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getExamTypeByExamId(int patientExamId) async {
    try {
      final response = await ApiClient.getAuth(
          'parameters/exam-type?patientExamId=$patientExamId'
      );

      if (response['success'] != true) return _defaultExamType;

      final data = response['data'];
      final examName = data?['exam_name'] as String?;

      return examName?.isNotEmpty == true ? examName : _defaultExamType;
    } catch (e) {
      return _defaultExamType;
    }
  }
}