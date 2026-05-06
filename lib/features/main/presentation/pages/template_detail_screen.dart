import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/block/text_content_block.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class TemplateDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const TemplateDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
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

            if (isEditing)
              ContinueButton(
                isEnabled: true,
                onPressed: () {
                  // Логика удаления
                },
                backgroundColor: Colors.white,
                borderColor: AppColors.error,
                text: 'Удалить',
              ),

          ],
        ),
      ),
    );
  }
}