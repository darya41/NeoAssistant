import 'package:flutter/material.dart';
import '../../../features/main/presentation/pages/create_reminder_screen.dart';

class AddReminderButton extends StatelessWidget {
  const AddReminderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateReminderScreen()),
          );
        },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 140, maxWidth: 160, minHeight: 70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Добавить\nнапоминание',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
