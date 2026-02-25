import 'package:flutter/material.dart';

import '../../models/reminder.dart';

class RemindersListUI extends StatelessWidget {
  final List<Reminder> reminders;
  final Function(int, bool) onCheckboxChange;

  const RemindersListUI({
    super.key,
    required this.reminders,
    required this.onCheckboxChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: reminders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return ListTile(
          leading: Checkbox(
            value: reminder.isCompleted,
            onChanged: (value) {
              onCheckboxChange(index, value ?? false);
            },
          ),
          title: Text(
            reminder.task,
            style: TextStyle(
              decoration: reminder.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: Text(reminder.date),
        );
      },
    );
  }
}

class AddReminderButtonUI extends StatelessWidget {
  const AddReminderButtonUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF44E4BF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('+ Добавить напоминание'),
      ),
    );
  }
}
