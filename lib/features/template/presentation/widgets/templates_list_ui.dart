import 'package:flutter/material.dart';
import 'package:neo_friend/features/template/domain/entities/exam_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../pages/template_detail_screen.dart';

class TemplatesListUI extends StatelessWidget {
  final List<ExamType> templates;
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
    if (templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: AppColors.neutral_25,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет доступных шаблонов',
              style: TextStyle(fontSize: 16, color: AppColors.neutral_50),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand_40,
              ),
              child: const Text('Создать шаблон'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: templates.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: AppColors.neutral_5,
      ),
      itemBuilder: (context, index) {
        final template = templates[index];

        return ListTile(
          title: Text(
            template.name,
            style: const TextStyle(fontSize: 16),
          ),
          onTap: () {
            if (!isEditing) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TemplateDetailScreen(
                    title: template.name,
                    examId: template.examTypeId,
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