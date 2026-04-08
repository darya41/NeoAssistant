import 'package:flutter/material.dart';
import 'package:neo_friend/features/reminders/presentation/pages/reminders_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/block/text_content_block.dart';
import '../../../../shared/widgets/buttons/action_button.dart';
import '../view_models/reminder_detail_viewmodel.dart';
import '../widgets/edit_reminder_form.dart';
import '../widgets/error_view.dart';
import '../widgets/reminder_detail_app_bar.dart';

class ReminderDetailScreen extends StatefulWidget {
  final int reminderId;
  final String title;
  final String description;

  const ReminderDetailScreen({
    super.key,
    required this.reminderId,
    required this.title,
    required this.description,
  });

  @override
  State<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  late final ReminderDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ReminderDetailViewModel(
      reminderId: widget.reminderId,
      initialTitle: widget.title,
      initialDescription: widget.description,
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleMarkAsCompleted() async {
    final success = await _viewModel.markAsCompleted(context);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напоминание выполнено!'),
          backgroundColor: AppColors.primary,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RemindersPageScreen()),
          );
        }
      });
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${_viewModel.errorMessage}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final success = await _viewModel.deleteReminder(context);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напоминание удалено'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context, true);
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${_viewModel.errorMessage}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleToggleEditing() {
    _viewModel.toggleEditing();
  }

  Future<void> _handleSave() async {
    await _viewModel.saveChanges();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading) {
      return _buildLoadingScaffold();
    }

    if (_viewModel.errorMessage != null) {
      return _buildErrorScaffold();
    }

    return Scaffold(
      appBar: ReminderDetailAppBar(
        isEditing: _viewModel.isEditing,
        onSave: _handleSave,
        onEdit: _handleToggleEditing,
        onBack: _handleBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: _viewModel.isEditing
                    ? EditReminderForm(
                        title: _viewModel.title,
                        description: _viewModel.description,
                        onTitleChanged: _viewModel.updateTitle,
                        onDescriptionChanged: _viewModel.updateDescription,
                    )
                    : TextContentBlock(
                        title: widget.title,
                        description: widget.description,
                ),
              ),
            ),
            const Spacer(),
            if (_viewModel.isLoading)
              const CircularProgressIndicator()
            else if (_viewModel.isEditing)
              ActionButton(
                onPressed: _handleDelete,
                backgroundColor: Colors.white,
                borderColor: AppColors.error,
                text: 'Удалить',
              )
            else if (!_viewModel.isCompleted)
                ActionButton(
                  onPressed: _handleMarkAsCompleted,
                  backgroundColor: const Color(0xFFACF3E3),
                  borderColor: AppColors.primary,
                  text: 'Выполнено',
                )
              else
                Container(),
          ],
        ),
      ),
    );
  }

  Scaffold _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Scaffold _buildErrorScaffold() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: ErrorView(
        errorMessage: _viewModel.errorMessage!,
        onRetry: () => _viewModel.clearError(),
      ),
    );
  }
}