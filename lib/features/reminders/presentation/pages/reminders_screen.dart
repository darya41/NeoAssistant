import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/buttons/action_button.dart';
import '../view_models/reminders_viewmodel.dart';
import '../widgets/error_view.dart';
import '../widgets/reminders_app_bar.dart';
import 'create_reminder_screen.dart';
import '../../../main/presentation/widgets/navigation/custom_bottom_navigation_bar.dart';
import '../widgets/reminders_list_ui.dart';

class RemindersPageScreen extends StatefulWidget {
  const RemindersPageScreen({super.key});

  @override
  State<RemindersPageScreen> createState() => _RemindersPageScreenState();
}

class _RemindersPageScreenState extends State<RemindersPageScreen> {
  late final RemindersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RemindersViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleCheckboxChange(int index, bool? value) async {
    if (value == null) return;

    final success = await _viewModel.toggleReminderStatus(index, value);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка обновления статуса'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleDelete(int index) async {
    final success = await _viewModel.deleteReminder(index);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напоминание удалено'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка удаления'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleAddReminder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateReminderScreen()),
    );

    if (result == true) {
      _viewModel.refreshAfterCreate();
    }
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
      appBar: RemindersAppBar(
        isEditing: _viewModel.isEditing,
        onToggleSort: _viewModel.toggleSort,
        onToggleEditing: _viewModel.toggleEditing,
      ),
      body: _buildBody(),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 1,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ActionButton(
          onPressed: _handleAddReminder,
          backgroundColor: const Color(0xFFACF3E3),
          borderColor: AppColors.primary,
          text: '+ Добавить напоминание',
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return ErrorView(
        errorMessage: _viewModel.errorMessage!,
        onRetry: () => _viewModel.loadReminders(),
      );
    }

    if (_viewModel.isEmpty) {
      return const Center(
        child: Text('Нет напоминаний'),
      );
    }

    return RemindersListUI(
      reminders: _viewModel.sortedReminders,
      onCheckboxChange: _handleCheckboxChange,
      onDelete: _handleDelete,
      isEditing: _viewModel.isEditing,
    );
  }
}