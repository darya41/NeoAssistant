import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_strings.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/daily_exam_view_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../view_models/add_daily_exam_viewmodel.dart';
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
  late final AddDailyExamViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddDailyExamViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    _viewModel.onTriedToSubmit();

    if (!_viewModel.isFormValid) return;

    try {
      final examId = await _viewModel.saveExam(widget.patientId);

      if (mounted && examId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ежедневный осмотр успешно добавлен!'),
            backgroundColor: AppColors.brand_40,
          ),
        );

        await Future.delayed(const Duration(seconds: 4));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DailyExamViewScreen(
                patientId: widget.patientId,
                examId: examId,
              ),
            ),
          );
        }
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
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _viewModel.onDateSelected(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _viewModel.selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      _viewModel.onTimeSelected(picked);
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
        backgroundColor: AppColors.neutral_0,
        elevation: 0,
        foregroundColor: AppColors.neutral_90,
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
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Дата и время осмотра',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Дата',
                                    errorText: _viewModel.dateError,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Text(
                                    _viewModel.selectedDate != null
                                        ? '${_viewModel.selectedDate!.day.toString().padLeft(2, '0')}.${_viewModel.selectedDate!.month.toString().padLeft(2, '0')}.${_viewModel.selectedDate!.year}'
                                        : 'Выберите дату',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () => _selectTime(context),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Время',
                                    errorText: _viewModel.timeError,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Text(
                                    _viewModel.selectedTime != null
                                        ? _viewModel.selectedTime!.format(context)
                                        : 'Выберите время',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              child: Text('Нет параметров для ежедневного осмотра'),
                            )
                          else
                            DailyExamForm(
                              parameters: _viewModel.parameters,
                              parameterValues: _viewModel.parameterValues,
                              onParameterChanged: _viewModel.onParameterChanged,
                            ),
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
                    textColor: _viewModel.isFormValid ? AppColors.neutral_0 : AppColors.neutral_90,
                    isEnabled: _viewModel.isFormValid,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}