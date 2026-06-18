import 'package:flutter/material.dart';
import 'package:neo_friend/features/main/data/repositories/patient_repository.dart';
import 'package:neo_friend/features/patient_card/data/repositories/favorite_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../patient_card/domain/entities/patient.dart';
import '../../../patient_card/presentation/pages/patient_details_screen.dart';
import '../../domain/entities/doctor.dart';
import '../../data/repositories/profile_repository.dart';

class DoctorProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  final PatientRepository _patientRepository = PatientRepository();

  Doctor? _doctor;
  bool _isLoading = true;
  String? _errorMessage;

  Doctor? get doctor => _doctor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get techLevelId => _doctor?.techLevelId;

  DoctorProfileViewModel() {
    _checkTokenAndLoadData();
  }

  Future<void> _checkTokenAndLoadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final isLoggedIn = await TokenStorage.isLoggedIn();

    if (!isLoggedIn) {
      _errorMessage = 'Не авторизован. Войдите снова.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _loadDoctorData();
    } catch (e) {
      if (e.toString().contains('401') || e.toString().contains('истек')) {
        final refreshed = await ApiClient.refreshToken();
        if (refreshed) {
          await _loadDoctorData();
        } else {
          _errorMessage = 'Сессия истекла. Войдите снова.';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _loadDoctorData() async {
    final data = await TokenStorage.getDoctorData();

    if (data == null) {
      _errorMessage = 'Данные не найдены. Войдите снова.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _doctor = Doctor.fromJson(data);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() async {
    await _checkTokenAndLoadData();
  }

  void updateDoctor(Doctor updatedDoctor) {
    _doctor = updatedDoctor;
    notifyListeners();
  }

  Future<void> refreshFromServer() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final doctor = await _profileRepository.getProfile();
      _doctor = doctor;
      await TokenStorage.saveDoctorData(doctor.toJson());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    await TokenStorage.clearAll();
    _doctor = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<List<int>> getFavoritePatientIds() async {
    try {
      return await _favoriteRepository.getFavoritePatientIds();
    } catch (e) {
      return [];
    }
  }

  Future<List<Patient>> getFavoritePatients() async {
    try {
      final favoriteIds = await _favoriteRepository.getFavoritePatientIds();

      final List<Patient> patients = [];
      for (final id in favoriteIds) {
        try {
          final patient = await _patientRepository.getPatientById(id);
          patients.add(patient);
        } catch (e) {
          print('Error loading patient $id: $e');
        }
      }

      return patients;
    } catch (e) {
      return [];
    }
  }

  Future<Patient?> getPatientById(int patientId) async {
    try {
      return await _patientRepository.getPatientById(patientId);
    } catch (e) {
      return null;
    }
  }

  Future<int?> getCurrentTechLevelId() async {
    if (_doctor?.techLevelId != null) {
      return _doctor!.techLevelId;
    }

    final data = await TokenStorage.getDoctorData();
    if (data != null) {
      final doctor = Doctor.fromJson(data);
      return doctor.techLevelId;
    }

    return null;
  }

  void navigateToPatientDetails(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
      ),
    );
  }
}