import 'package:flutter/material.dart';
import 'reminder_card.dart';
import '../../../../shared/widgets/buttons/add_reminder_button.dart';

class RemindersStats extends StatelessWidget {
  const RemindersStats({super.key});

  static const List<Map<String, dynamic>> remindersData = [
    {'count': '19', 'label': 'напоминаний сегодня', 'isToday': true},
    {'count': '5', 'label': 'напоминаний 26 сентября', 'isToday': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF44E4BF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4, width: 20,),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: remindersData.length + 1,
                itemBuilder: (context, index) {
                  if (index == remindersData.length) {
                    return const AddReminderButton();
                  }
                  final data = remindersData[index];
                  return ReminderCard(
                    count: data['count'] as String,
                    label: data['label'] as String,
                    isToday: data['isToday'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
