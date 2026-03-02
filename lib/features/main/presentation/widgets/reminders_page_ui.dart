import 'package:flutter/material.dart';
import '../../../../models/reminder.dart';
import '../pages/reminder_detail_screen.dart';

class RemindersListUI extends StatelessWidget {
  final List<Reminder> reminders;
  final Function(int, bool) onCheckboxChange;
  final bool isEditing;

  const RemindersListUI({
    super.key,
    required this.reminders,
    required this.onCheckboxChange,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Reminder>> groupedReminders = {};
    for (final reminder in reminders) {
      groupedReminders.putIfAbsent(reminder.date, () => []).add(reminder);
    }

    return ListView(
      children: groupedReminders.entries.map((entry) {
        final date = entry.key;
        final remindersForDate = entry.value;

        return Column(
          children: [
            ListTile(
              title: Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF44E4BF),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReminderDetailScreen(title: 'фффф', description: 'фффф',),
                  ),
                );
              },
            ),

            ...remindersForDate.map((reminder) => ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReminderDetailScreen(
                      title: reminder.task,
                      description: 'Дополнительная информация о задаче...',
                    ),
                  ),
                );
              },
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: reminder.isCompleted
                      ? Border.all(
                    color: Colors.grey,
                    width: 1,
                  )
                      : null,
                ),
                child: Center(
                  child: Checkbox(
                    value: reminder.isCompleted,
                    onChanged: (value) => onCheckboxChange(reminders.indexOf(reminder), value ?? false),
                    checkColor: Color(0xFF77EBF5),
                    fillColor: WidgetStateProperty.all(Colors.transparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              title: Text(
                reminder.task,
                style: TextStyle(
                  color: reminder.isCompleted ? Colors.grey : Colors.black,
                  decoration: reminder.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              trailing: isEditing && !reminder.isCompleted
                  ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
                color: Colors.red,
              )
                  : null,
            )),

          ],
        );
      }).toList(),
    );
  }
}
