import 'package:flutter/material.dart';

class PasswordRulesDialog extends StatelessWidget {
  const PasswordRulesDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PasswordRulesDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Требования к паролю',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('• Не менее 8 символов'),
          SizedBox(height: 4),
          Text('• Содержит заглавные и строчные буквы'),
          SizedBox(height: 4),
          Text('• Содержит цифры'),
          SizedBox(height: 4),
          Text('• Содержит специальные символы'),
          SizedBox(height: 8),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color(0xFF44E4BF),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}