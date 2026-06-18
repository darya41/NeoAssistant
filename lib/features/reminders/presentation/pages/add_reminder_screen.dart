import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../view_models/add_reminder_viewmodel.dart';
import '../widgets/reminder_form.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late final AddReminderViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddReminderViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleSave() async {
    final success = await _viewModel.saveReminder(context);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напоминание создано!'),
          backgroundColor: AppColors.brand_40,
        ),
      );
      Navigator.pop(context, true);
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleDateTap() {
    _viewModel.selectDate(context);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новое напоминание'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ReminderForm(
                  dateDisplay: _viewModel.dateDisplay,
                  titleIsEmpty: _viewModel.titleIsEmpty,
                  descriptionIsEmpty: _viewModel.descriptionIsEmpty,
                  onTitleChanged: (text) {},
                  onDateTap: _handleDateTap,
                  onDescriptionChanged: (text) {},
                  backgroundColor: AppColors.neutral_5,
                  titleController: _viewModel.titleController,
                  descriptionController: _viewModel.descriptionController,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_viewModel.isSaving)
              const Center(child: CircularProgressIndicator())
            else
              ContinueButton(
                text: "Сохранить",
                onPressed: _handleSave,
                isEnabled: _viewModel.isFormValid,
              ),
          ],
        ),
      ),
    );
  }
}