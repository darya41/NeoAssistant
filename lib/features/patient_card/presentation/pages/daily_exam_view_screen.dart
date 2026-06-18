import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_models/daily_exam_view_viewmodel.dart';

class DailyExamViewScreen extends StatefulWidget {
  final int patientId;
  final int examId;

  const DailyExamViewScreen({
    super.key,
    required this.patientId,
    required this.examId,
  });

  @override
  State<DailyExamViewScreen> createState() => _DailyExamViewScreenState();
}

class _DailyExamViewScreenState extends State<DailyExamViewScreen> {
  late final DailyExamViewViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DailyExamViewViewModel(
      patientId: widget.patientId,
      examId: widget.examId,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        if (_viewModel.error != null && !_viewModel.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _viewModel.showErrorSnackBar(context);
          });
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
              tooltip: 'Назад',
            ),
            title: Text(_viewModel.examTitle),
            backgroundColor: AppColors.brand_40,
            automaticallyImplyLeading: false,
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

    if (_viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _viewModel.error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _viewModel.loadParameters(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (_viewModel.parameters.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_information,
              size: 64,
              color: AppColors.neutral_50,
            ),
            SizedBox(height: 16),
            Text(
              'Нет данных для отображения',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.neutral_50,
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              _viewModel.examDateTime.isNotEmpty
                  ? _viewModel.examDateTime
                  : 'Дата не указана',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral_50,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Дневник наблюдений',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _viewModel.buildParametersText(),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}