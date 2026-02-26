import 'package:flutter/material.dart';
import '../../screens/main/create_reminder_screen.dart';

class AddReminderCardButton extends StatelessWidget {
  const AddReminderCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateReminderScreen()),
        );
      },
      child: Container(
        width: 380,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFACF3E3),
          border: Border.all(
            color: Color(0xFF1DC9A1),
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            '+ Добавить напоминание',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
