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
    final isLoadingMore = viewModel.isLoadingMore;
    final hasMore = viewModel.hasMore;
    final error = viewModel.error;

    return Column(
      children: [
        Expanded(
          child: _buildContent(
            viewModel,
            medications,
            isLoading,
            isLoadingMore,
            hasMore,
            error,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      MedicationsViewModel viewModel,
      List<Medication> medications,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      String? error,
      ) {
    if (isLoading && medications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка...'),
          ],
        ),
      );
    }

    if (error != null && medications.isEmpty) {
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

    if (medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет лекарственных препаратов',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoadingMore && hasMore && !isLoading) {
            final maxScroll = scrollInfo.metrics.pixels;
            final maxExtent = scrollInfo.metrics.maxScrollExtent;
            if (maxScroll >= maxExtent - 200) {
              viewModel.loadNextPage();
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: medications.length + (hasMore ? 1 : 0),
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
      ),
    );
  }
}