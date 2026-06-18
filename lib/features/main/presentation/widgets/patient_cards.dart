import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/block/patient_card.dart';
import '../view_models/patient_search_viewmodel.dart';

class PatientCards extends StatelessWidget {
  const PatientCards({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PatientSearchViewModel>();

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.refresh();
      },
      child: _buildContent(viewModel, context),
    );
  }

  Widget _buildContent(PatientSearchViewModel viewModel, BuildContext context) {
    final patients = viewModel.displayedPatients;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (viewModel.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (patients.isEmpty) {
      final isSearchMode = viewModel.searchQuery.isNotEmpty && viewModel.searchQuery.length >= 2;

      if (isSearchMode || viewModel.hasActiveFilters) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: AppColors.neutral_60),
              const SizedBox(height: 16),
              const Text(
                'Ничего не найдено',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                isSearchMode
                    ? 'По запросу "${viewModel.searchQuery}" пациентов не найдено'
                    : 'По выбранным фильтрам пациентов не найдено',
                style: const TextStyle(fontSize: 14, color: AppColors.neutral_60),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (isSearchMode) {
                    viewModel.clearSearch();
                  } else {
                    viewModel.clearFilters();
                  }
                },
                child: const Text('Очистить'),
              ),
            ],
          ),
        );
      }

      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information, size: 64, color: AppColors.neutral_60),
            SizedBox(height: 16),
            Text(
              'Нет пациентов',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте первого пациента',
              style: TextStyle(fontSize: 14, color: AppColors.neutral_60),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!viewModel.isLoadingMore &&
            viewModel.hasMore &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          viewModel.loadMorePatients();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: patients.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == patients.length) {
            if (viewModel.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return const SizedBox.shrink();
          }
          final patient = patients[index];
          return PatientCard(patient: patient);
        },
      ),
    );
  }
}