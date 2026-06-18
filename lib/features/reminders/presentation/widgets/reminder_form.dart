import 'package:flutter/material.dart';

class ReminderForm extends StatelessWidget {
  final String dateDisplay;
  final bool titleIsEmpty;
  final bool descriptionIsEmpty;
  final Function(String) onTitleChanged;
  final VoidCallback onDateTap;
  final Function(String) onDescriptionChanged;
  final Color backgroundColor;
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;

  const ReminderForm({
    super.key,
    required this.dateDisplay,
    required this.titleIsEmpty,
    required this.descriptionIsEmpty,
    required this.onTitleChanged,
    required this.onDateTap,
    required this.onDescriptionChanged,
    required this.backgroundColor,
    this.titleController,
    this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Название',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: onTitleChanged,
          ),
        ),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: onDateTap,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                dateDisplay,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Container(
          height: 120,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Описание',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
              onChanged: onDescriptionChanged,
            ),
          ),
        ),
      ],
    );
  }
}