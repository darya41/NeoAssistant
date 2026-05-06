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
  final Function()? onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;

  const RemindersListUI({
    super.key,
    required this.reminders,
    required this.onCheckboxChange,
    required this.onDelete,
    required this.isEditing,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Reminder>> groupedReminders = {};
    for (final reminder in reminders) {
      final dateKey = reminder.dateString;
      groupedReminders.putIfAbsent(dateKey, () => []).add(reminder);
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }
      },
      child: ListView(
        children: [
          ...groupedReminders.entries.map((entry) {
            final date = entry.key;
            final remindersForDate = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand_40,
                      fontSize: 16,
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
                          checkColor: AppColors.brand_40,
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
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDelete(index),
                      color: AppColors.error,
                    )
                        : null,
                  );
                }),
                const Divider(height: 1, thickness: 0.5),
              ],
            );
          }),

          if (hasMore)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: isLoadingMore
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: onLoadMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand_40,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Ещё (3 дня)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          if (!hasMore && reminders.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  'Показаны все напоминания',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}