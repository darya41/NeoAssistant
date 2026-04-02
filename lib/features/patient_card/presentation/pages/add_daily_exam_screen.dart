import 'package:flutter/material.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/daily_exam_view_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/medical_parameter.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../../data/repositories/parameter_repository.dart';
import '../../data/repositories/patient_exam_repository.dart';
import '../../domain/validators/exam_form_validator.dart';
import '../widgets/daily_exam_form.dart';

class AddDailyExamScreen extends StatefulWidget {
  final int patientId;

  const AddDailyExamScreen({
    super.key,
    required this.patientId
  });

  @override
  State<AddDailyExamScreen> createState() => _AddDailyExamScreenState();
}

class _AddDailyExamScreenState extends State<AddDailyExamScreen> {
  final ParameterRepository _parameterRepository = ParameterRepository();

  final int examId = 2;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;
  bool _isLoadingParameters = true;
  String? _parametersError;

  List<MedicalParameter> _parameters = [];
  final Map<int, dynamic> _parameterValues = {};

  bool _triedToSubmit = false;

  @override
  void initState() {
    super.initState();
    _loadParameters();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _loadParameters() async {
    setState(() {
      _isLoadingParameters = true;
      _parametersError = null;
    });

    try {
      final parameters = await _parameterRepository.getParameters(examId);
      setState(() {
        _parameters = parameters;
        _isLoadingParameters = false;
      });
    } catch (e) {
      setState(() {
        _parametersError = e.toString().replaceFirst('Exception: ', '');
        _isLoadingParameters = false;
      });
    }
  }

  bool get _isFormValid {
    return ExamFormValidator.isFormValid(
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      parameters: _parameters,
      parameterValues: _parameterValues,
    );
  }

  String? get _dateError {
    return ExamFormValidator.getDateError(_selectedDate, _triedToSubmit);
  }

  String? get _timeError {
    return ExamFormValidator.getTimeError(_selectedTime, _triedToSubmit);
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

  Future<void> _handleSave() async {
    setState(() => _triedToSubmit = true);

    if (!_isFormValid) return;

    setState(() => _isSaving = true);

    try {
      final doctorData = await TokenStorage.getDoctorData();
      final doctorId = doctorData?['doctor_id'] ?? doctorData?['id'];

      if (doctorId == null) {
        throw Exception('Не удалось получить ID врача. Пожалуйста, войдите заново.');
      }

      final examData = {
        'patient_id': widget.patientId,
        'exam_id': examId,
        'doctor_id': doctorId,
        'date_time': _getCombinedDateTime().toIso8601String(),
      };


      final patientsExamsId = await PatientExamRepository.createPatientExam(examData);

      await PatientExamRepository.saveExamParameters(
        patientsExamsId,
        _parameterValues,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ежедневный осмотр успешно добавлен!'),
            backgroundColor: AppColors.primary,
          ),
        );
        await Future.delayed(const Duration(seconds: 4));

        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => DailyExamViewScreen(
              patientId: widget.patientId, examId: patientsExamsId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ежедневный осмотр'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (_isLoadingParameters)
                      const Center(child: CircularProgressIndicator())
                    else if (_parametersError != null)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Ошибка загрузки параметров: $_parametersError',
                              style: const TextStyle(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _loadParameters,
                              child: const Text('Повторить'),
                            ),
                          ],
                        ),
                      )
                    else if (_parameters.isEmpty)
                        const Center(
                          child: Text('Нет параметров для ежедневного осмотра'),
                        )
                      else
                        DailyExamForm(
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          parameters: _parameters,
                          parameterValues: _parameterValues,
                          onParameterChanged: (id, value) {
                            setState(() {
                              _parameterValues[id] = value;
                            });
                          },
                          showValidationErrors: _triedToSubmit,
                          dateError: _dateError,
                          timeError: _timeError,
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_isSaving)
              const Center(child: CircularProgressIndicator())
            else
              SaveButton(
                onPressed: _handleSave,
                backgroundColor: _isFormValid ? AppColors.primary : AppColors.background,
                borderColor: _isFormValid ? AppColors.primary : AppColors.border,
                textColor: _isFormValid ? AppColors.white : AppColors.black,
                isEnabled: _isFormValid,
              ),
          ],
        ),
      ),
    );
  }
}