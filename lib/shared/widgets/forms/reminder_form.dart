import 'package:flutter/material.dart';


class ReminderForm extends StatefulWidget {
  final String dateDisplay;
  final bool titleIsEmpty;
  final bool descriptionIsEmpty;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onDateTap;
  final ValueChanged<String> onDescriptionChanged;
  final Color backgroundColor;

  const ReminderForm({
    super.key,
    required this.dateDisplay,
    required this.titleIsEmpty,
    required this.descriptionIsEmpty,
    required this.onTitleChanged,
    required this.onDateTap,
    required this.onDescriptionChanged,
    this.backgroundColor = const Color(0xFFF3F3F3),
  });

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Название',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              textAlign: !widget.titleIsEmpty ? TextAlign.left : TextAlign.center,
              onChanged: widget.onTitleChanged,
            ),
          ),
          SizedBox(height: 16),

          Container(
            height: 56,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.dateDisplay,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onTap: widget.onDateTap,
              ),
            ),
          ),
          SizedBox(height: 16),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Описание',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  textAlign: !widget.descriptionIsEmpty ? TextAlign.left : TextAlign.center,
                  onChanged: widget.onDescriptionChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
