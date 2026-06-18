import '../../domain/entities/doctor.dart';
import '../../../../core/storage/token_storage.dart';
import '../service/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService = ProfileService();

  Future<Doctor> updateProfile({
    required String lastName,
    required String firstName,
    String? patronymic,
    required String email,
    required String phone,
    required int specializationId,
    String? password,
  }) async {
    final Map<String, dynamic> data = {
      'lastName': lastName,
      'firstName': firstName,
      'patronymic': patronymic,
      'email': email,
      'phone': phone,
      'specializationId': specializationId,
    };

    if (password != null && password.isNotEmpty) {
      data['password'] = password;
    }

    final response = await _profileService.updateProfile(data);

    if (response['success'] == true) {
      final doctorData = response['doctor'] as Map<String, dynamic>;
      final doctor = Doctor.fromJson(doctorData);

      await TokenStorage.saveDoctorData(doctor.toJson());

      return doctor;
    } else {
      throw Exception(response['error'] ?? 'Ошибка обновления профиля');
    }
  }

  Future<Doctor> getProfile() async {
    final response = await _profileService.getProfile();

    if (response['success'] == true) {
      final doctorData = response['doctor'] as Map<String, dynamic>;
      return Doctor.fromJson(doctorData);
    } else {
      throw Exception(response['error'] ?? 'Ошибка загрузки профиля');
    }
  }
}