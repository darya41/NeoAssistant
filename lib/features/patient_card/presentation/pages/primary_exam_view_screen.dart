import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_models/primary_exam_view_viewmodel.dart';
import '../widgets/form_fields/consent_section.dart';
import '../widgets/form_fields/parameters_list.dart';

class PrimaryExamViewScreen extends StatefulWidget {
  final int patientId;
  final int examTypeId;

  const PrimaryExamViewScreen({
    super.key,
    required this.patientId,
    required this.examTypeId,
  });

  @override
  State<PrimaryExamViewScreen> createState() => _PrimaryExamViewScreenState();
}

class _PrimaryExamViewScreenState extends State<PrimaryExamViewScreen> {
  late final PrimaryExamViewViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PrimaryExamViewViewModel(
      patientId: widget.patientId,
      examTypeId: widget.examTypeId,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        if (_viewModel.hasError && _viewModel.error != 'Первичный осмотр не найден') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _viewModel.showErrorSnackBar(context);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Первичный осмотр новорождённого'),
            backgroundColor: AppColors.primary,
            actions: [
              if (_viewModel.hasError)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _viewModel.refresh(),
                  tooltip: 'Обновить',
                ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _viewModel.error == 'Первичный осмотр не найден'
                  ? Icons.search_off
                  : Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _viewModel.error!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _viewModel.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить попытку'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (!_viewModel.hasParameters) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.medical_information,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Нет данных для отображения',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _viewModel.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ConsentSectionWidget(),
          const SizedBox(height: 24),
          ParametersList(parameters: _viewModel.parameters),
        ],
      ),
    );
  }
}