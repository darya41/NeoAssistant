import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../patient_card/domain/entities/medical_parameter.dart';
import '../view_models/template_detail_viewmodel.dart';

class TemplateDetailScreen extends StatefulWidget {
  final String title;
  final int examId;

  const TemplateDetailScreen({
    super.key,
    required this.title,
    required this.examId,
  });

  @override
  State<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends State<TemplateDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TemplateDetailViewModel()..loadParameters(widget.examId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: AppColors.brand_40,
        ),
        body: Consumer<TemplateDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: const TextStyle(color: AppColors.error),
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

            if (viewModel.parameters.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: AppColors.neutral_60),
                    SizedBox(height: 16),
                    Text(
                      'Нет данных для отображения',
                      style: TextStyle(fontSize: 16, color: AppColors.neutral_60),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.parameters.length,
              itemBuilder: (context, index) {
                final parameter = viewModel.parameters[index];
                return _buildParameterCard(parameter);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildParameterCard(MedicalParameter parameter) {
    String formattedValue = '';
    if (parameter.unit != null && parameter.unit!.isNotEmpty) {
      formattedValue = ' ${parameter.unit}';
    }
    else{
      formattedValue = ' Не указано';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parameter.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral_90,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neutral_5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutral_25),
              ),
              child: parameter.options != null && parameter.options!.isNotEmpty
                  ? Wrap(
                spacing: 8,
                runSpacing: 4,
                children: parameter.options!.map((option) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.neutral_5,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neutral_25),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral_90,
                      ),
                    ),
                  );
                }).toList(),
              )
                  : Text(
                formattedValue,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral_90,
                ),
              ),
            ),

            if (parameter.description != null && parameter.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppColors.neutral_50),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      parameter.description!,
                      style: const TextStyle(fontSize: 11, color: AppColors.neutral_50),
                    ),
                  ),
                ],
              ),
            ],

            if (parameter.valueType.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Тип: ${_getValueTypeName(parameter.valueType)}',
                  style: const TextStyle(fontSize: 10, color: AppColors.neutral_50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getValueTypeName(String valueType) {
    switch (valueType.toLowerCase()) {
      case 'number':
        return 'Числовое значение';
      case 'zn':
        return 'Значение';
      case 'enum':
        return 'Перечисление';
      default:
        return valueType;
    }
  }
}