import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/medication.dart';
import '../view_model/medications_viewmodel.dart';
import 'medication_card.dart';

class MedicationsList extends StatelessWidget {
  const MedicationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicationsViewModel(),
      child: const _MedicationsListContent(),
    );
  }
}

class _MedicationsListContent extends StatelessWidget {
  const _MedicationsListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicationsViewModel>();
    final medications = viewModel.medications;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;
    final hasMore = viewModel.hasMore;

    return Expanded(
      child: _buildContent(
        context,
        viewModel,
        medications,
        isLoading,
        error,
        hasMore,
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      MedicationsViewModel viewModel,
      List<Medication> medications,
      bool isLoading,
      String? error,
      bool hasMore,
      ) {
    if (isLoading && medications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && medications.isEmpty) {
      return _buildErrorWidget(error, viewModel);
    }

    if (medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет препаратов',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoading && hasMore) {
          final maxScroll = scrollInfo.metrics.pixels;
          final maxExtent = scrollInfo.metrics.maxScrollExtent;
          if (maxScroll >= maxExtent - 200) {
            viewModel.loadNextPage();
          }
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: medications.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == medications.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final medication = medications[index];
          return MedicationCard(medication: medication);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error, MedicationsViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Ошибка: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.refresh(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}