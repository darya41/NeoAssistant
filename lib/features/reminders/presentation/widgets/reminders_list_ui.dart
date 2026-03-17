import 'package:flutter/material.dart';
import '../../../../models/reminder.dart';
import '../pages/reminder_detail_screen.dart';

class RemindersListUI extends StatelessWidget {
  final List<Reminder> reminders;
  final Function(int, bool) onCheckboxChange;
  final Function(int) onDelete;
  final bool isEditing;
  final Function()? onRefresh; // добавим callback для обновления

  const RemindersListUI({
    super.key,
    required this.reminders,
    required this.onCheckboxChange,
    required this.onDelete,
    required this.isEditing,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Reminder>> groupedReminders = {};
    for (final reminder in reminders) {
      final dateKey = reminder.dateString;
      groupedReminders.putIfAbsent(dateKey, () => []).add(reminder);
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
            ),
            ...remindersForDate.asMap().entries.map((item) {
              final index = reminders.indexOf(item.value);
              final reminder = item.value;

              return ListTile(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReminderDetailScreen(
                        reminderId: reminder.id,
                        title: reminder.title,
                        description: reminder.description ?? '',
                      ),
                    ),
                  );

                  // Если результат true - обновляем список
                  if (result == true && onRefresh != null) {
                    onRefresh!();
                  }
                },
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: reminder.isCompleted
                        ? Border.all(color: Colors.grey, width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Checkbox(
                      value: reminder.isCompleted,
                      onChanged: (value) => onCheckboxChange(index, value ?? false),
                      checkColor: const Color(0xFF77EBF5),
                      fillColor: WidgetStateProperty.all(Colors.transparent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                title: Text(
                  reminder.title,
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
                  onPressed: () => onDelete(index),
                  color: Colors.red,
                )
                    : null,
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}