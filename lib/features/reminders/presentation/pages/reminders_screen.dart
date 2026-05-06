import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../view_models/reminders_viewmodel.dart';
import '../widgets/error_view.dart';
import '../widgets/reminders_app_bar.dart';
import 'add_reminder_screen.dart';
import '../../../main/presentation/widgets/navigation/custom_bottom_navigation_bar.dart';
import '../../../main/presentation/widgets/navigation/analytics_bottom_bar.dart';
import '../widgets/reminders_list_ui.dart';

class RemindersPageScreen extends StatefulWidget {
  final bool useAnalyticsBottomBar;

  const RemindersPageScreen({
    super.key,
    this.useAnalyticsBottomBar = false,
  });

  @override
  State<RemindersPageScreen> createState() => _RemindersPageScreenState();
}

class _RemindersPageScreenState extends State<RemindersPageScreen> {
  late final RemindersViewModel _viewModel;
  final int _currentIndex = 1;

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
          backgroundColor: AppColors.brand_40,
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
      MaterialPageRoute(builder: (context) => const AddReminderScreen()),
    );

    if (result == true) {
      _viewModel.refreshAfterCreate();
    }
  }

  Future<void> _handleLoadMore() async {
    await _viewModel.loadMoreDays();
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
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ContinueButton(
          isEnabled: true,
          onPressed: _handleAddReminder,
          backgroundColor: const Color(0xFFACF3E3),
          borderColor: AppColors.brand_40,
          text: '+ Добавить напоминание',
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    if (widget.useAnalyticsBottomBar) {
      return AnalyticsBottomBar(
        currentIndex: _currentIndex,
        isGuest: false,
      );
    } else {
      return CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      );
    }
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Нет напоминаний',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Добавьте первое напоминание',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleAddReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand_40,
                foregroundColor: Colors.white,
              ),
              child: const Text('Создать напоминание'),
            ),
          ],
        ),
      );
    }

    return RemindersListUI(
      reminders: _viewModel.reminders,
      onCheckboxChange: _handleCheckboxChange,
      onDelete: _handleDelete,
      isEditing: _viewModel.isEditing,
      onRefresh: () => _viewModel.loadReminders(),
      onLoadMore: _handleLoadMore,
      hasMore: _viewModel.hasMore,
      isLoadingMore: _viewModel.isLoadingMore,
    );
  }
}