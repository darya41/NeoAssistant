import 'package:flutter/material.dart';
import 'package:neo_friend/features/main/presentation/pages/create_reminder_screen.dart';
import '../../../../shared/widgets/buttons/create_button.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/templates_list_ui.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  bool isEditing = false;

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  final List<String> _templates = [
    'О пациенте — исследование',
    'Обследования успешны',
    'О пациенте — решения',
    'Результаты',
  ];

  void _handleCreateTemplate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateReminderScreen()),
    );
  }

  void _deleteTemplate(int index) {
    //удаление
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шаблоны'),

        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Colors.black,
            ),
            onPressed: _toggleEditing,
          ),
        ],
        backgroundColor: const Color(0xFF44E4BF),
      ),
      body: Column(
        children: [
          Expanded(
            child: TemplatesListUI(
              templates: _templates,
              onEditPressed: _toggleEditing,
              onCreatePressed: _handleCreateTemplate,
              isEditing: isEditing,
              onDeleteTemplate: _deleteTemplate,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
            child: CreateButton(
              onPressed: _handleCreateTemplate,
              backgroundColor: const Color(0xFFACF3E3),
              borderColor: const Color(0xFF1DC9A1),
              text: '+ Создать шаблон',
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}