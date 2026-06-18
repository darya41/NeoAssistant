import 'package:flutter/material.dart';
import '../../../auth/data/repositories/specialization_repository.dart';
import '../../../auth/domain/entities/specialization.dart';
import '../../../auth/domain/validators/auth_validator.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/doctor.dart';

class DoctorEditProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();
  final SpecializationRepository _specializationRepository = SpecializationRepository();

  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<Specialization> _specializations = [];
  int? _selectedSpecializationId;
  String? _currentSpecializationName;
  bool _isLoadingSpecializations = false;
  bool _isSaving = false;
  String? _specializationError;
  String? _saveError;

  List<Specialization> get specializations => _specializations;
  int? get selectedSpecializationId => _selectedSpecializationId;
  String? get currentSpecializationName => _currentSpecializationName;
  bool get isLoadingSpecializations => _isLoadingSpecializations;
  bool get isSaving => _isSaving;
  String? get specializationError => _specializationError;
  String? get saveError => _saveError;

  bool get isFormValid {
    if (lastNameController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        _selectedSpecializationId == null) {
      return false;
    }

    if (passwordController.text.isNotEmpty) {
      if (passwordController.text.length < 6) return false;
      if (passwordController.text != confirmPasswordController.text) return false;
    }

    return true;
  }

  String? get emailError {
    final email = emailController.text.trim();
    if (email.isEmpty) return null;
    return AuthValidator.getEmailError(email);
  }

  String? get passwordError {
    final password = passwordController.text;
    if (password.isEmpty) return null;
    return AuthValidator.getPasswordError(password);
  }

  String? get confirmPasswordError {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;
    if (confirm.isEmpty) return null;
    if (password != confirm) return 'Пароли не совпадают';
    return null;
  }

  DoctorEditProfileViewModel(Doctor doctor) {
    _initControllers(doctor);
    _loadSpecializations();
  }

  void _initControllers(Doctor doctor) {
    lastNameController.text = doctor.lastName;
    firstNameController.text = doctor.firstName;
    patronymicController.text = doctor.patronymic ?? '';
    emailController.text = doctor.email;

    phoneController.text = doctor.workPhone ?? doctor.personalPhone ?? '';

    _currentSpecializationName = doctor.specialization;

    lastNameController.addListener(_onFormChanged);
    firstNameController.addListener(_onFormChanged);
    emailController.addListener(_onFormChanged);
    passwordController.addListener(_onFormChanged);
    confirmPasswordController.addListener(_onFormChanged);
    phoneController.addListener(_onFormChanged);

  }

  void _onFormChanged() {
    notifyListeners();
  }

  Future<void> _loadSpecializations() async {
    _isLoadingSpecializations = true;
    _specializationError = null;
    notifyListeners();

    try {
      final specializations = await _specializationRepository.getSpecializations();
      _specializations = specializations;
      _isLoadingSpecializations = false;

      if (_currentSpecializationName != null && _currentSpecializationName!.isNotEmpty) {
        final matchingSpec = _specializations.firstWhere(
              (spec) => spec.name == _currentSpecializationName,
          orElse: () => Specialization(id: 0, name: ''),
        );
        if (matchingSpec.id != 0) {
          _selectedSpecializationId = matchingSpec.id;
        }
      }
      notifyListeners();
    } catch (e) {
      _specializationError = 'Ошибка загрузки должностей: ${e.toString().replaceFirst('Exception: ', '')}';
      _isLoadingSpecializations = false;
      notifyListeners();
    }
  }

  void selectSpecialization(int? id) {
    _selectedSpecializationId = id;
    _saveError = null;
    notifyListeners();
  }

  Future<Doctor?> saveChanges() async {
    if (!isFormValid) return null;

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    try {
      final updatedDoctor = await _profileRepository.updateProfile(
        lastName: lastNameController.text,
        firstName: firstNameController.text,
        patronymic: patronymicController.text.isNotEmpty
            ? patronymicController.text
            : null,
        email: emailController.text,
        phone: phoneController.text,
        specializationId: _selectedSpecializationId!,
        password: passwordController.text.isNotEmpty
            ? passwordController.text
            : null,
      );

      _isSaving = false;
      notifyListeners();

      return updatedDoctor;
    } catch (e) {
      _saveError = e.toString().replaceFirst('Exception: ', '');
      _isSaving = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _saveError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    lastNameController.removeListener(_onFormChanged);
    firstNameController.removeListener(_onFormChanged);
    emailController.removeListener(_onFormChanged);
    passwordController.removeListener(_onFormChanged);
    confirmPasswordController.removeListener(_onFormChanged);
    phoneController.removeListener(_onFormChanged);

    lastNameController.dispose();
    firstNameController.dispose();
    patronymicController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> loadSpecializations() async {
    await _loadSpecializations();
  }
}