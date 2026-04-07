import 'package:flutter/material.dart';
import '../../data/repositories/exam_parameter_repository.dart';
import '../../domain/entities/medical_parameter.dart';
import '../../domain/validators/exam_form_validator.dart';
import '../../data/repositories/patient_exam_repository.dart';
import '../../../../core/storage/token_storage.dart';

class AddDailyExamViewModel extends ChangeNotifier {
  final ExamParameterRepository _parameterRepository = ExamParameterRepository();
  final PatientExamRepository _patientExamRepository = PatientExamRepository();
  final int examId = 2;

  List<MedicalParameter> _parameters = [];
  final Map<int, dynamic> _parameterValues = {};
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;
  bool _isLoadingParameters = true;
  String? _parametersError;
  bool _triedToSubmit = false;

  List<MedicalParameter> get parameters => _parameters;
  Map<int, dynamic> get parameterValues => _parameterValues;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  bool get isSaving => _isSaving;
  bool get isLoadingParameters => _isLoadingParameters;
  String? get parametersError => _parametersError;
  bool get triedToSubmit => _triedToSubmit;

  bool get isFormValid {
    return ExamFormValidator.isFormValid(
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      parameters: _parameters,
      parameterValues: _parameterValues,
    );
  }

  String? get dateError {
    return ExamFormValidator.getDateError(_selectedDate, _triedToSubmit);
  }

  String? get timeError {
    return ExamFormValidator.getTimeError(_selectedTime, _triedToSubmit);
  }

  AddDailyExamViewModel() {
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    loadParameters();
  }

  Future<void> loadParameters() async {
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

  void onDateSelected(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void onTimeSelected(TimeOfDay time) {
    _selectedTime = time;
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

  Future<int?> saveExam(int patientId) async {
    _isSaving = true;
    notifyListeners();

    try {
      final doctorData = await TokenStorage.getDoctorData();
      final doctorId = doctorData?['doctor_id'] ?? doctorData?['id'];

      if (doctorId == null) {
        throw Exception('Не удалось получить ID врача');
      }

      final examData = {
        'patient_id': patientId,
        'exam_id': examId,
        'doctor_id': doctorId,
        'date_time': _getCombinedDateTime().toIso8601String(),
      };

      final patientsExamsId = await _patientExamRepository.createPatientExam(examData);
      await _parameterRepository.saveExamParameters(patientsExamsId, _parameterValues);

      return patientsExamsId;
    } catch (e) {
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void reset() {
    _parameterValues.clear();
    _triedToSubmit = false;
    _parametersError = null;
    notifyListeners();
  }
}