import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/reminder.dart';
import '../pages/reminder_detail_screen.dart';

class RemindersListUI extends StatelessWidget {
  final List<Reminder> reminders;
  final Function(int, bool) onCheckboxChange;
  final Function(int) onDelete;
  final bool isEditing;
  final Function()? onRefresh;

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
                  color: AppColors.primary,
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
                      checkColor: AppColors.primary,
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
                  color: AppColors.error,
                )
                    : null,
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}