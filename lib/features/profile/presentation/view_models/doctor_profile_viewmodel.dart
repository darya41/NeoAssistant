import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/doctor.dart';
import '../../data/repositories/profile_repository.dart';

class DoctorProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  Doctor? _doctor;
  bool _isLoading = true;
  String? _errorMessage;

  Doctor? get doctor => _doctor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}