import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../pages/template_detail_screen.dart';

class TemplatesListUI extends StatelessWidget {
  final List<String> templates;
  final VoidCallback onEditPressed;
  final VoidCallback onCreatePressed;
  final bool isEditing;
  final Function(int)? onDeleteTemplate;

  const TemplatesListUI({
    super.key,
    required this.templates,
    required this.onEditPressed,
    required this.onCreatePressed,
    required this.isEditing,
    this.onDeleteTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: templates.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: Colors.grey[300],
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            templates[index],
            style: const TextStyle(fontSize: 16),
          ),
          onTap: () {
            if (!isEditing) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemplateDetailScreen(
                    title: templates[index],
                    description: 'папапапапапапа',
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}