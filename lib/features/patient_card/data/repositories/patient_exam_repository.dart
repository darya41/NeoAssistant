import '../../../../core/network/api_client.dart';

class PatientExamRepository {

  static Future<int> createPatient(Map<String, dynamic> patientData) async {
    try {

      final response = await ApiClient.postAuth('patients', patientData);

      if (response is Map<String, dynamic> && response['success'] == true) {
        final patientId = response['data']['patient_id'];
        return patientId;
      } else {
        throw Exception(response['error'] ?? 'Ошибка создания пациента');
      }
    } catch (e) {
      throw Exception('Ошибка создания пациента: $e');
    }
  }

  static Future<int> createPatientExam(Map<String, dynamic> examData) async {
    try {

      final response = await ApiClient.postAuth('patient-exams', examData);


      if (response is Map<String, dynamic> && response['success'] == true) {
        final examId = response['data']['patients_exams_id'];
        return examId;
      } else {
        throw Exception(response['error'] ?? 'Ошибка создания осмотра');
      }
    } catch (e) {
      throw Exception('Ошибка создания осмотра: $e');
    }
  }

  static Future<void> saveExamParameters(
      int patientsExamsId,
      Map<int, dynamic> parameters,
      ) async {
    try {
      final List<Map<String, dynamic>> paramsList = [];

      for (var entry in parameters.entries) {
        paramsList.add({
          'medical_parameter_id': entry.key,
          'value': entry.value.toString(),
        });
      }


      final response = await ApiClient.postAuth(
        'patient-exams/$patientsExamsId/parameters',
        {'parameters': paramsList},
      );


      if (response is Map<String, dynamic> && response['success'] == true) {
      } else {
        throw Exception(response['error'] ?? 'Ошибка сохранения параметров');
      }
    } catch (e) {
      throw Exception('Ошибка сохранения параметров: $e');
    }
  }
}