import 'package:flutter/material.dart';

class EditReminderForm extends StatelessWidget {
  final String title;
  final String description;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const EditReminderForm({
    super.key,
    required this.title,
    required this.description,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: title,
          onChanged: onTitleChanged,
          decoration: const InputDecoration(
            labelText: 'Заголовок',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: description,
          onChanged: onDescriptionChanged,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Описание',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}