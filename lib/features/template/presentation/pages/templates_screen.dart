import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neo_friend/features/reminders/presentation/pages/add_reminder_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../main/presentation/widgets/navigation/custom_bottom_navigation_bar.dart';
import '../view_models/exam_types_viewmodel.dart';
import '../widgets/templates_list_ui.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        try {
          context.read<ExamTypesViewModel>().loadExamTypes();
        } catch (e) {
          print('Provider not found, will be loaded by the provider itself');
        }
      }
    });
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _handleCreateTemplate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddReminderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamTypesViewModel()..loadExamTypes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Шаблоны'),
          backgroundColor: AppColors.brand_40,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (context.mounted) {
                  context.read<ExamTypesViewModel>().refresh();
                }
              },
            ),
          ],
        ),
        body: Consumer<ExamTypesViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.examTypes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (viewModel.error != null && viewModel.examTypes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.neutral_50),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: TextStyle(color: AppColors.neutral_60),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.refresh(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand_40,
                      ),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.examTypes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, size: 64, color: AppColors.neutral_50),
                    const SizedBox(height: 16),
                    Text(
                      'Нет доступных шаблонов',
                      style: TextStyle(fontSize: 16, color: AppColors.neutral_60),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _handleCreateTemplate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand_40,
                      ),
                      child: const Text('Создать шаблон'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: TemplatesListUI(
                    templates: viewModel.examTypes,
                    onEditPressed: _toggleEditing,
                    onCreatePressed: _handleCreateTemplate,
                    isEditing: isEditing,
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
      ),
    );
  }
}