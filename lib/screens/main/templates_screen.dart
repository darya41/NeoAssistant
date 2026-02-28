import 'package:flutter/material.dart';
import '../../components/button/create_template_button.dart';
import '../../widgets/main/bottom_navigation_bar.dart';
import '../../widgets/main/templates_list_ui.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final List<String> _templates = [
    'О пациенте — исследование',
    'Обследования успешны',
    'О пациенте — решения',
    'Результаты',
  ];

  void _handleEditTemplates() {
    // редактирования шаблонов
  }

  void _handleCreateTemplate() {
    // создание нового шаблона
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шаблоны'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _handleEditTemplates,
          ),
        ],
        backgroundColor: Color(0xFF44E4BF),
      ),
      body: Column(
        children: [
          Expanded(
            child: TemplatesListUI(
              templates: _templates,
              onEditPressed: _handleEditTemplates,
              onCreatePressed: _handleCreateTemplate,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CreateTemplateButton(
              onPressed: _handleCreateTemplate,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}

