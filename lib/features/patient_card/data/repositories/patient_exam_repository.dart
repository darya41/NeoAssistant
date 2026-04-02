import '../../../../core/network/api_client.dart';

class PatientExamRepository {
  static const String _defaultErrorMessage = 'Неизвестная ошибка';

  static Map<String, dynamic> _handleResponse(dynamic response, String context) {
    if (response is! Map<String, dynamic>) {
      throw Exception('$context: Неверный формат ответа от сервера');
    }

    if (response['success'] != true) {
      throw Exception(response['error'] ?? '$_defaultErrorMessage при $context');
    }

    return response;
  }

  static Future<int> createPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await ApiClient.postAuth('patients', patientData);
      _handleResponse(response, 'создании пациента');

      final patientId = response['data']?['patient_id'];
      if (patientId == null) {
        throw Exception('Создание пациента: ID не получен от сервера');
      }

      return patientId as int;
    } catch (e) {
      throw Exception('Ошибка создания пациента: $e');
    }
  }

  static Future<int> createPatientExam(Map<String, dynamic> examData) async {
    try {
      final response = await ApiClient.postAuth('patient-exams', examData);
      _handleResponse(response, 'создании осмотра');

      final examId = response['data']?['patients_exams_id'];
      if (examId == null) {
        throw Exception('Создание осмотра: ID не получен от сервера');
      }

      return examId as int;
    } catch (e) {
      throw Exception('Ошибка создания осмотра: $e');
    }
  }

  static Future<void> saveExamParameters(
      int patientsExamsId,
      Map<int, dynamic> parameters,
      ) async {
    if (patientsExamsId <= 0) {
      throw Exception('Сохранение параметров: некорректный ID осмотра');
    }

    try {
      final List<Map<String, dynamic>> paramsList = [];

      for (var entry in parameters.entries) {
        final value = entry.value?.toString().trim() ?? '';
        if (value.isNotEmpty) {
          paramsList.add({
            'medical_parameter_id': entry.key,
            'value': value,
          });
        }
      }

      if (paramsList.isEmpty) {
        return;
      }

      final response = await ApiClient.postAuth(
        'patient-exams/$patientsExamsId/parameters',
        {'parameters': paramsList},
      );

      _handleResponse(response, 'сохранении параметров');
    } catch (e) {
      throw Exception('Ошибка сохранения параметров: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPatientExamsByType({
    required int patientId,
    required int examTypeId,
  }) async {
    if (patientId <= 0) {
      throw Exception('Загрузка осмотров: некорректный ID пациента');
    }

    if (examTypeId <= 0) {
      throw Exception('Загрузка осмотров: некорректный ID типа осмотра');
    }

    try {
      final response = await ApiClient.getAuth(
          'patient-exams?patientId=$patientId&examTypeId=$examTypeId'
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка загрузки осмотров');
      }

      final List<dynamic> data = response['data'] ?? [];
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки осмотров: $e');
    }
  }
}