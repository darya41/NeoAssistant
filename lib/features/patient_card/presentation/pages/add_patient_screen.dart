import 'package:flutter/material.dart';
import '../../../../models/medical_parameter.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../../data/repositories/parameter_repository.dart';
import '../widgets/patient_form.dart';

class AddPatientScreen extends StatefulWidget {

  const AddPatientScreen({
    super.key
  });

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final ParameterRepository _parameterRepository = ParameterRepository();

  final TextEditingController _motherFioController = TextEditingController();
  final TextEditingController _historyNumberController = TextEditingController();
  final TextEditingController _childHeightController = TextEditingController();
  final TextEditingController _childWeightController = TextEditingController();

  int examId = 1;
  String _dateDisplay = 'Дата: 00/00/0000';
  DateTime? _selectedDate;
  String _timeDisplay = 'Час рождения: 00:00';
  TimeOfDay? _selectedTime;
  String _selectedGender = '';
  bool _isSaving = false;
  bool _isLoadingParameters = true;
  String? _parametersError;

  List<MedicalParameter> _parameters = [];
  final Map<int, dynamic> _parameterValues = {};

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);
  static const _activeColor = Color(0xFF44E4BF);

  bool _motherFioIsEmpty = true;
  bool _historyNumberIsEmpty = true;
  bool _childHeightIsEmpty = true;
  bool _childWeightIsEmpty = true;

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
    if (_motherFioIsEmpty ||
        _historyNumberIsEmpty ||
        _childHeightIsEmpty ||
        _childWeightIsEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedGender.isEmpty) {
      return false;
    }

    for (var param in _parameters) {
      if (!_parameterValues.containsKey(param.id)) {
        return false;
      }
      if (param.valueType == 'enum' && _parameterValues[param.id] == null) {
        return false;
      }
      if (param.valueType == 'number' && _parameterValues[param.id] == null) {
        return false;
      }
    }

    return true;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final dateString = '${picked.day}/${picked.month}/${picked.year}';
      setState(() {
        _dateDisplay = 'Дата: $dateString';
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeDisplay = 'Час рождения: ${picked.format(context)}';
        _selectedTime = picked;
      });
    }
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
    if (!_isFormValid) return;

    setState(() {
      _isSaving = true;
    });

    try {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пациент успешно добавлен!'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
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
                    PatientForm.searchField(
                      _motherFioController,
                          () => setState(() => _motherFioIsEmpty = _motherFioController.text.isEmpty),
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.dateField(
                      _dateDisplay,
                      _selectDate,
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.timeField(
                      _timeDisplay,
                      _selectTime,
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.historyField(
                      _historyNumberController,
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.heightField(
                      _childHeightController,
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.weightField(
                      _childWeightController,
                      _defaultBackgroundColor,
                      _borderColor,
                    ),
                    const SizedBox(height: 16),

                    PatientForm.genderField(
                      selectedGender: _selectedGender,
                      onMaleSelected: () => setState(() => _selectedGender = 'мужской'),
                      onFemaleSelected: () => setState(() => _selectedGender = 'женский'),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Параметры обследования:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                        ..._parameters.map((param) => _buildParameterField(param)).toList(),
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