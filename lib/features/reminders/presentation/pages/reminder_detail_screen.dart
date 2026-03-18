import 'package:flutter/material.dart';
import 'package:neo_friend/features/reminders/presentation/pages/reminders_screen.dart';
import '../../../../shared/widgets/block/text_content_block.dart';
import '../../../../shared/widgets/buttons/create_button.dart';
import '../../data/repositories/reminder_repository.dart';

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
  bool isEditing = false;
  bool _isLoading = false;
  bool _isCompleted = false;
  String? _errorMessage;

  final ReminderRepository _repository = ReminderRepository();

  @override
  void initState() {
    super.initState();
    _isCompleted = false;
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reminder = await _repository.getReminderById(widget.reminderId);
      setState(() {
        _isCompleted = reminder.isCompleted;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsCompleted() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _repository.markAsCompleted(widget.reminderId);

      setState(() {
        _isCompleted = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Напоминание выполнено!'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RemindersPageScreen()),
            );
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $_errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteReminder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: const Text('Вы уверены, что хотите удалить это напоминание?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _repository.deleteReminder(widget.reminderId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Напоминание удалено'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReminder,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Colors.black,
            ),
            onPressed: _toggleEditing,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: TextContentBlock(
                  title: widget.title,
                  description: widget.description,
                ),
              ),
            ),
            const Spacer(),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (isEditing)
              CreateButton(
                onPressed: _deleteReminder,
                backgroundColor: Colors.white,
                borderColor: Colors.red,
                text: 'Удалить',
              )
            else if (!_isCompleted)
                CreateButton(
                  onPressed: _markAsCompleted,
                  backgroundColor: const Color(0xFFACF3E3),
                  borderColor: const Color(0xFF1DC9A1),
                  text: 'Выполнено',
                )
              else
                Container(),
          ],
        ),
      ),
    );
  }
}