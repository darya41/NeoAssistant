import 'package:flutter/material.dart';
import '../../../../models/reminder.dart';
import '../../../../shared/widgets/buttons/create_button.dart';
import 'create_reminder_screen.dart';
import '../../../main/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../data/repositories/reminder_repository.dart';
import '../widgets/reminders_list_ui.dart';

class RemindersPageScreen extends StatefulWidget {
  const RemindersPageScreen({super.key});

  @override
  State<RemindersPageScreen> createState() => _RemindersPageScreenState();
}

class _RemindersPageScreenState extends State<RemindersPageScreen> {
  bool _sortNewFirst = true;
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<Reminder> _reminders = [];
  final ReminderRepository _repository = ReminderRepository();

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reminders = await _repository.getReminders();
      setState(() {
        _reminders = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _toggleSort() {
    setState(() {
      _sortNewFirst = !_sortNewFirst;
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _handleCheckboxChange(int index, bool? value) async {
    if (value == null) return;

    final reminder = _reminders[index];

    // Оптимистичное обновление UI
    setState(() {
      _reminders[index].isCompleted = value;
    });

    try {
      await _repository.toggleReminderStatus(reminder.id, value);
    } catch (e) {
      // Откатываем изменения в случае ошибки
      setState(() {
        _reminders[index].isCompleted = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка обновления: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDelete(int index) async {
    final reminder = _reminders[index];

    // Оптимистичное удаление
    setState(() {
      _reminders.removeAt(index);
    });

    try {
      await _repository.deleteReminder(reminder.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напоминание удалено'),
          backgroundColor: Color(0xFF44E4BF),
        ),
      );
    } catch (e) {
      // Возвращаем элемент в случае ошибки
      setState(() {
        _reminders.insert(index, reminder);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка удаления: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Reminder> get _sortedReminders {
    final sorted = List<Reminder>.from(_reminders);
    if (_sortNewFirst) {
      sorted.sort((a, b) => b.date.compareTo(a.date));
    } else {
      sorted.sort((a, b) => a.date.compareTo(b.date));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Сначала новые'),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: _toggleSort,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                color: Colors.black,
              ),
              onPressed: _toggleEditing,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF44E4BF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReminders,
              child: const Text('Повторить'),
            ),
          ],
        ),
      )
          : _reminders.isEmpty
          ? const Center(
        child: Text('Нет напоминаний'),
      )
          : RemindersListUI(
        reminders: _sortedReminders,
        onCheckboxChange: _handleCheckboxChange,
        onDelete: _handleDelete,
        isEditing: _isEditing,
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 1,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: CreateButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateReminderScreen()),
            );
            if (result == true) {
              _loadReminders();
            }
          },
          backgroundColor: const Color(0xFFACF3E3),
          borderColor: const Color(0xFF1DC9A1),
          text: '+ Добавить напоминание',
        ),
      ),
    );
  }
}