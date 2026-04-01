import '../../../../core/network/api_client.dart';
import '../../../../models/medical_parameter.dart';
import '../../../../models/medical_parameter_value.dart';

class ParameterRepository {
  Future<List<MedicalParameter>> getParameters(int examId) async {
    try {
      final response = await ApiClient.getAuth('parameters?examId=$examId');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];

        final parameters = data.map((json) {
          return MedicalParameter.fromJson(json);
        }).toList();

        return parameters;
      } else {
        throw Exception(response['error'] ?? 'Ошибка загрузки параметров');
      }
    } catch (e) {
      rethrow;
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

      if (response['success'] == true) {
        final data = response['data'];

        if (data != null && data['patient_exam_id'] != null) {
          return data['patient_exam_id'] as int;
        } else {
          return null;
        }
      } else {
        return null;
      }
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

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];

        final parameters = data.map((json) {
          return MedicalParameterValue(
            name: json['name'],
            value: json['value'],
          );
        }).toList();

        return parameters;
      } else {
        throw Exception(response['error'] ?? 'Ошибка загрузки параметров');
      }
    } catch (e) {
      rethrow;
    }
  }
}