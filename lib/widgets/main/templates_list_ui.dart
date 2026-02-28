import 'package:flutter/material.dart';

class TemplatesListUI extends StatelessWidget {
  final List<String> templates;
  final VoidCallback onEditPressed;
  final VoidCallback onCreatePressed;

  const TemplatesListUI({
    super.key,
    required this.templates,
    required this.onEditPressed,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
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
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            // логика показа шаблона
          },
        );
      },
    );
  }
}
