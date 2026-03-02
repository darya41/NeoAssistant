import 'package:flutter/material.dart';
import '../../../../shared/widgets/block/text_content_block.dart';
import '../../../../shared/widgets/buttons/create_button.dart';

class ReminderDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const ReminderDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  bool isEditing = false;

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Colors.black,
            ),
            onPressed: _toggleEditing,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: TextContentBlock(
                  title: widget.title,
                  description: widget.description,
                ),
              ),
            ),
            Spacer(),
            isEditing
                ? CreateButton(
                    onPressed: () {
                      // Логика выполнения
                    },
                    backgroundColor: Colors.white,
                    borderColor: Colors.red,
                    text: 'Удалить',
                  )
                : CreateButton(
                    onPressed: () {
                      // Логика выполнения
                    },
                    backgroundColor: Color(0xFFACF3E3),
                    borderColor: Color(0xFF1DC9A1),
                    text: 'Выполнено',
                  ),
          ],
        ),
      ),
    );
  }
}
