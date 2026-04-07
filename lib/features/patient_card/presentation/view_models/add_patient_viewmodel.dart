import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/repositories/exam_parameter_repository.dart';
import '../../data/repositories/patient_repository.dart';
import '../../domain/entities/medical_parameter.dart';
import '../../../../models/mother.dart';
import '../../data/repositories/patient_exam_repository.dart';

class AddPatientViewModel extends ChangeNotifier {
  final ExamParameterRepository _parameterRepository = ExamParameterRepository();
final PatientRepository _patientRepository = PatientRepository();
final PatientExamRepository _patientExamRepository = PatientExamRepository();

final int examId = 1;

  final TextEditingController motherFioController = TextEditingController();
  final TextEditingController historyNumberController = TextEditingController();
  final TextEditingController childHeightController = TextEditingController();
  final TextEditingController childWeightController = TextEditingController();

  int _selectedMotherId = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedGender = '';
  String? _selectedBloodGroup;
  String? _selectedRhFactor;
  bool _isSaving = false;
  bool _isLoadingParameters = true;
  String? _parametersError;
  bool _triedToSubmit = false;

  List<MedicalParameter> _parameters = [];
  final Map<int, dynamic> _parameterValues = {};

  int get selectedMotherId => _selectedMotherId;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get selectedGender => _selectedGender;
  String? get selectedBloodGroup => _selectedBloodGroup;
  String? get selectedRhFactor => _selectedRhFactor;
  bool get isSaving => _isSaving;
  bool get isLoadingParameters => _isLoadingParameters;
  String? get parametersError => _parametersError;
  bool get triedToSubmit => _triedToSubmit;
  List<MedicalParameter> get parameters => _parameters;
  Map<int, dynamic> get parameterValues => _parameterValues;

  String? get motherFioError {
    if (!_triedToSubmit) return null;
    return _selectedMotherId == 0 ? 'Выберите или добавьте мать' : null;
  }

  String? get historyNumberError {
    if (!_triedToSubmit) return null;
    return historyNumberController.text.trim().isEmpty ? AppStrings.requiredField : null;
  }

  String? get heightError {
    if (!_triedToSubmit) return null;
    return childHeightController.text.trim().isEmpty ? AppStrings.requiredField : null;
  }

  String? get weightError {
    if (!_triedToSubmit) return null;
    return childWeightController.text.trim().isEmpty ? AppStrings.requiredField : null;
  }

  String? get dateError {
    if (!_triedToSubmit) return null;
    return _selectedDate == null ? AppStrings.requiredField : null;
  }

  String? get timeError {
    if (!_triedToSubmit) return null;
    return _selectedTime == null ? AppStrings.requiredField : null;
  }

  String? get genderError {
    if (!_triedToSubmit) return null;
    return _selectedGender.isEmpty ? AppStrings.requiredField : null;
  }

  String? get bloodGroupError {
    if (!_triedToSubmit) return null;
    return _selectedBloodGroup == null ? AppStrings.requiredField : null;
  }

  String? get rhFactorError {
    if (!_triedToSubmit) return null;
    return _selectedRhFactor == null ? AppStrings.requiredField : null;
  }

  bool get isFormValid {
    if (motherFioController.text.trim().isEmpty ||
        historyNumberController.text.trim().isEmpty ||
        childHeightController.text.trim().isEmpty ||
        childWeightController.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedGender.isEmpty ||
        _selectedBloodGroup == null ||
        _selectedRhFactor == null) {
      return false;
    }

    for (var param in _parameters) {
      if (!_parameterValues.containsKey(param.id)) {
        return false;
      }
      final value = _parameterValues[param.id];
      if (value == null || value.toString().trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  AddPatientViewModel() {
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    _isLoadingParameters = true;
    _parametersError = null;
    notifyListeners();

    try {
      _parameters = await _parameterRepository.getParameters(examId);
    } catch (e) {
      _parametersError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingParameters = false;
      notifyListeners();
    }
  }

  void loadParameters() => _loadParameters();

  void onMotherSelected(Mother mother) {
    _selectedMotherId = mother.id;
    motherFioController.text = mother.fullName;
    notifyListeners();
  }

  void onDateSelected(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void onTimeSelected(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void onGenderSelected(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void onBloodGroupChanged(String? group) {
    _selectedBloodGroup = group;
    notifyListeners();
  }

  void onRhFactorChanged(String? rh) {
    _selectedRhFactor = rh;
    notifyListeners();
  }

  void onParameterChanged(int id, dynamic value) {
    _parameterValues[id] = value;
    notifyListeners();
  }

  void onTriedToSubmit() {
    _triedToSubmit = true;
    notifyListeners();
  }

  DateTime _getCombinedDateTime() {
    final date = _selectedDate!;
    final time = _selectedTime!;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<bool> savePatient(BuildContext context) async {
    _isSaving = true;
    notifyListeners();

    try {
      final doctorData = await TokenStorage.getDoctorData();
      final doctorId = doctorData?['doctor_id'] ?? doctorData?['id'];

      if (doctorId == null) {
        throw Exception('Не удалось получить ID врача. Пожалуйста, войдите заново.');
      }

      final patientData = {
        'mother_id': _selectedMotherId > 0 ? _selectedMotherId : null,
        'date_of_birth': _getCombinedDateTime().toIso8601String(),
        'gender': _selectedGender == 'Мужской' ? 'MALE' : 'FEMALE',
        'number_history': historyNumberController.text.trim(),
        'blood_group': _selectedBloodGroup,
        'rh_factor': _selectedRhFactor,
        'weight': double.parse(childWeightController.text.trim()),
        'height': double.parse(childHeightController.text.trim()),
      };

      final patientId = await _patientRepository.createPatient(patientData);

      final examData = {
        'patient_id': patientId,
        'exam_id': examId,
        'doctor_id': doctorId,
        'date_time': _getCombinedDateTime().toIso8601String(),
      };

      final patientsExamsId = await _patientExamRepository.createPatientExam(examData);
      await _parameterRepository.saveExamParameters(patientsExamsId, _parameterValues);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пациент и осмотр успешно добавлены!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void reset() {
    _selectedMotherId = 0;
    _selectedDate = null;
    _selectedTime = null;
    _selectedGender = '';
    _selectedBloodGroup = null;
    _selectedRhFactor = null;
    _triedToSubmit = false;
    _parameterValues.clear();
    motherFioController.clear();
    historyNumberController.clear();
    childHeightController.clear();
    childWeightController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    motherFioController.dispose();
    historyNumberController.dispose();
    childHeightController.dispose();
    childWeightController.dispose();
    super.dispose();
  }
}