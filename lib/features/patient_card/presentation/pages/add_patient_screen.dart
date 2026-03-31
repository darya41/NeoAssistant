import 'package:flutter/material.dart';
import '../../../../models/medical_parameter.dart';
import '../../../../models/mother.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../../data/repositories/parameter_repository.dart';
import '../../data/repositories/patient_exam_repository.dart';
import '../widgets/patient_form.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final ParameterRepository _parameterRepository = ParameterRepository();

  final TextEditingController _motherFioController = TextEditingController();
  final TextEditingController _historyNumberController = TextEditingController();
  final TextEditingController _childHeightController = TextEditingController();
  final TextEditingController _childWeightController = TextEditingController();

  int _selectedMotherId = 0;
  int examId = 1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedGender = '';
  String? _selectedBloodGroup;
  String? _selectedRhFactor;
  bool _isSaving = false;
  bool _isLoadingParameters = true;
  String? _parametersError;

  List<MedicalParameter> _parameters = [];
  final Map<int, dynamic> _parameterValues = {};

  bool _triedToSubmit = false;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _activeColor = Color(0xFF44E4BF);

  @override
  void initState() {
    super.initState();
    _loadParameters();
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
    if (_motherFioController.text.trim().isEmpty ||
        _historyNumberController.text.trim().isEmpty ||
        _childHeightController.text.trim().isEmpty ||
        _childWeightController.text.trim().isEmpty ||
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

      final patientData = {
        'mother_id': _selectedMotherId > 0 ? _selectedMotherId : null,
        'date_of_birth': _getCombinedDateTime().toIso8601String(),
        'gender': _selectedGender == 'Мужской' ? 'MALE' : 'FEMALE',
        'number_history': _historyNumberController.text.trim(),
        'blood_group': _selectedBloodGroup,
        'rh_factor': _selectedRhFactor,
        'weight_at_birth': double.parse(_childWeightController.text.trim()),
        'height_at_birth': double.parse(_childHeightController.text.trim()),
      };

      final patientId = await PatientExamRepository.createPatient(patientData);

      final examData = {
        'patient_id': patientId,
        'exam_id': examId,
        'doctor_id': null,
        'date_time': _getCombinedDateTime().toIso8601String(),
      };

      final patientsExamsId =
      await PatientExamRepository.createPatientExam(examData);

      await PatientExamRepository.saveExamParameters(
        patientsExamsId,
        _parameterValues,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пациент и осмотр успешно добавлены!'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
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
  void dispose() {
    _motherFioController.dispose();
    _historyNumberController.dispose();
    _childHeightController.dispose();
    _childWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить пациента'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
                    PatientFormWidget(
                      motherFioController: _motherFioController,
                      historyNumberController: _historyNumberController,
                      heightController: _childHeightController,
                      weightController: _childWeightController,
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      selectedGender: _selectedGender,
                      selectedBloodGroup: _selectedBloodGroup,
                      selectedRhFactor: _selectedRhFactor,
                      onMotherSearchChanged: () {},
                      onMotherSelected: (Mother mother) {
                        setState(() {
                          _selectedMotherId = mother.id;
                          _motherFioController.text = mother.fullName;
                        });
                      },
                      onDateSelected: (date) {
                        setState(() => _selectedDate = date);
                      },
                      onTimeSelected: (time) {
                        setState(() => _selectedTime = time);
                      },
                      onGenderSelected: (gender) {
                        setState(() => _selectedGender = gender);
                      },
                      onBloodGroupChanged: (group) {
                        setState(() => _selectedBloodGroup = group);
                      },
                      onRhFactorChanged: (rh) {
                        setState(() => _selectedRhFactor = rh);
                      },
                      showValidationErrors: _triedToSubmit,
                      motherFioError: _triedToSubmit && _selectedMotherId == 0
                          ? 'Выберите или добавьте мать'
                          : null,
                      historyNumberError: _triedToSubmit && _historyNumberController.text.trim().isEmpty
                          ? 'Обязательное поле'
                          : null,
                      heightError: _triedToSubmit && _childHeightController.text.trim().isEmpty
                          ? 'Обязательное поле'
                          : null,
                      weightError: _triedToSubmit && _childWeightController.text.trim().isEmpty
                          ? 'Обязательное поле'
                          : null,
                      dateError: _triedToSubmit && _selectedDate == null
                          ? 'Обязательное поле'
                          : null,
                      timeError: _triedToSubmit && _selectedTime == null
                          ? 'Обязательное поле'
                          : null,
                      genderError: _triedToSubmit && _selectedGender.isEmpty
                          ? 'Обязательное поле'
                          : null,
                      bloodGroupError: _triedToSubmit && _selectedBloodGroup == null
                          ? 'Обязательное поле'
                          : null,
                      rhFactorError: _triedToSubmit && _selectedRhFactor == null
                          ? 'Обязательное поле'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    if (_isLoadingParameters)
                      const Center(child: CircularProgressIndicator())
                    else if (_parametersError != null)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Ошибка загрузки параметров: $_parametersError',
                              style: const TextStyle(color: Colors.red),
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
                          child: Text('Нет параметров для этого обследования'),
                        )
                      else
                        ..._parameters.map((param) => _buildParameterField(param)),
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
                backgroundColor: _isFormValid ? _activeColor : _defaultBackgroundColor,
                borderColor: _isFormValid ? _activeColor : _borderColor,
                textColor: _isFormValid ? Colors.white : Colors.black,
                isEnabled: _isFormValid,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterField(MedicalParameter param) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            param.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          if (param.valueType == 'enum' && param.options != null)
            _buildEnumField(param)
          else
            _buildTextField(param),
        ],
      ),
    );
  }

  Widget _buildEnumField(MedicalParameter param) {
    final options = param.options!;

    if (options.length <= 4) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          final isSelected = _parameterValues[param.id] == option;

          return GestureDetector(
            onTap: () {
              setState(() {
                _parameterValues[param.id] = option;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? _activeColor : _defaultBackgroundColor,
                border: Border.all(
                  color: isSelected ? _activeColor : _borderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _defaultBackgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _parameterValues[param.id],
        hint: const Text('Выберите значение'),
        isExpanded: true,
        underline: Container(),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _parameterValues[param.id] = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(MedicalParameter param) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _defaultBackgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: param.valueType == 'number'
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: param.unit != null
              ? 'Введите значение (${param.unit})'
              : 'Введите значение',
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: (value) {
          setState(() {
            _parameterValues[param.id] = value;
          });
        },
      ),
    );
  }
}