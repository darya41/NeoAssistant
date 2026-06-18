import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../domain/entities/medical_parameter.dart';
import '../view_models/add_patient_viewmodel.dart';
import '../widgets/patient_form.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  late final AddPatientViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddPatientViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    _viewModel.onTriedToSubmit();

    if (!_viewModel.isFormValid) return;

    final success = await _viewModel.savePatient(context);

    if (mounted && success) {
      Navigator.pop(context, true);
    }
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
        backgroundColor: AppColors.neutral_0,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PatientFormWidget(
                          motherFioController: _viewModel.motherFioController,
                          historyNumberController: _viewModel.historyNumberController,
                          heightController: _viewModel.childHeightController,
                          weightController: _viewModel.childWeightController,
                          selectedDate: _viewModel.selectedDate,
                          selectedTime: _viewModel.selectedTime,
                          selectedGender: _viewModel.selectedGender,
                          selectedBloodGroup: _viewModel.selectedBloodGroup,
                          selectedRhFactor: _viewModel.selectedRhFactor,
                          onMotherSearchChanged: () {},
                          onMotherSelected: _viewModel.onMotherSelected,
                          onDateSelected: _viewModel.onDateSelected,
                          onTimeSelected: _viewModel.onTimeSelected,
                          onGenderSelected: _viewModel.onGenderSelected,
                          onBloodGroupChanged: _viewModel.onBloodGroupChanged,
                          onRhFactorChanged: _viewModel.onRhFactorChanged,
                          showValidationErrors: _viewModel.triedToSubmit,
                          motherFioError: _viewModel.motherFioError,
                          historyNumberError: _viewModel.historyNumberError,
                          heightError: _viewModel.heightError,
                          weightError: _viewModel.weightError,
                          dateError: _viewModel.dateError,
                          timeError: _viewModel.timeError,
                          genderError: _viewModel.genderError,
                          bloodGroupError: _viewModel.bloodGroupError,
                          rhFactorError: _viewModel.rhFactorError,
                        ),
                        const SizedBox(height: 16),

                        if (_viewModel.isLoadingParameters)
                          const Center(child: CircularProgressIndicator())
                        else if (_viewModel.parametersError != null)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Ошибка загрузки параметров: ${_viewModel.parametersError}',
                                  style: const TextStyle(color: AppColors.error),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => _viewModel.loadParameters(),
                                  child: const Text(AppStrings.retry),
                                ),
                              ],
                            ),
                          )
                        else if (_viewModel.parameters.isEmpty)
                            const Center(
                              child: Text('Нет параметров для этого обследования'),
                            )
                          else
                            ..._viewModel.parameters.map((param) => _buildParameterField(param)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_viewModel.isSaving)
                  const Center(child: CircularProgressIndicator())
                else
                  ContinueButton(
                    onPressed: _handleSave,
                    text: "Сохранить",
                    backgroundColor: _viewModel.isFormValid ? AppColors.brand_40 : AppColors.neutral_5,
                    borderColor: _viewModel.isFormValid ? AppColors.brand_40 : AppColors.neutral_25,
                    textColor: _viewModel.isFormValid ? Colors.white : Colors.black,
                    isEnabled: _viewModel.isFormValid,
                  ),
              ],
            ),
          );
        },
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
    final currentValue = _viewModel.parameterValues[param.id];

    if (options.length <= 4) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          final isSelected = currentValue == option;

          return GestureDetector(
            onTap: () {
              _viewModel.onParameterChanged(param.id, option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brand_40 : AppColors.neutral_5,
                border: Border.all(
                  color: isSelected ? AppColors.brand_40 : AppColors.neutral_25,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? AppColors.neutral_0 : AppColors.neutral_90,
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
        color: AppColors.neutral_5,
        border: Border.all(color: AppColors.neutral_25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: currentValue,
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
          _viewModel.onParameterChanged(param.id, value);
        },
      ),
    );
  }

  Widget _buildTextField(MedicalParameter param) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral_5,
        border: Border.all(color: AppColors.neutral_25),
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
          _viewModel.onParameterChanged(param.id, value);
        },
      ),
    );
  }
}