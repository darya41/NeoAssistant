// data/services/patient_exam_service.dart
import '../../../../core/network/api_client.dart';

class PatientExamService {

  // Создание осмотра
  Future<Map<String, dynamic>> createPatientExam(Map<String, dynamic> examData) async {
    final response = await ApiClient.postAuth('patient-exams', examData);

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }



  // Получение осмотров по типу
  Future<Map<String, dynamic>> getPatientExamsByType({
    required int patientId,
    required int examTypeId,
  }) async {
    final response = await ApiClient.getAuth(
        'patient-exams?patientId=$patientId&examTypeId=$examTypeId'
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Неверный формат ответа от сервера');
    }

    return response;
  }
}