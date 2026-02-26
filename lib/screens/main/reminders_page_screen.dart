import 'package:flutter/material.dart';
import '../../components/button/add_reminder_card_button.dart';
import '../../models/reminder.dart';
import '../../widgets/main/bottom_navigation_bar.dart';
import '../../widgets/main/reminders_page_ui.dart';

class RemindersPageScreen extends StatefulWidget {
  const RemindersPageScreen({super.key});

  @override
  State<RemindersPageScreen> createState() => _RemindersPageScreenState();
}

class _RemindersPageScreenState extends State<RemindersPageScreen> {
  bool _sortNewFirst = true;

  final List<Reminder> _reminders = [
    Reminder(date: '19 октября 2025', task: 'Провести анкетирование', isCompleted: false),
    Reminder(date: '19 октября 2025', task: 'Выписать направление', isCompleted: true),
    Reminder(date: '19 октября 2025', task: 'Проверить ребёнка Иванова И.И.', isCompleted: true),
    Reminder(date: '18 октября 2025', task: 'Выписать направление', isCompleted: false),
    Reminder(date: '18 октября 2025', task: 'Плановая пятиминутка', isCompleted: false),
    Reminder(date: '18 октября 2025', task: 'Подготовить эпикризы', isCompleted: false),
  ];

  void _toggleSort() {
    setState(() {
      _sortNewFirst = !_sortNewFirst;
    });
  }

  void _handleCheckboxChange(int index, bool? value) {
    setState(() {
      if (value != null) {
        _reminders[index].isCompleted = value;
      }
    });
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
            const Icon(Icons.edit),
          ],
        ),
        backgroundColor: const Color(0xFF44E4BF),
      ),
      body: RemindersListUI(
        reminders: _sortedReminders,
        onCheckboxChange: _handleCheckboxChange,
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 1,
      ),
      floatingActionButton: AddReminderCardButton(),

    );
  }
}