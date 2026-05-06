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
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
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
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
            Icon(Icons.medical_information, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Нет пациентов',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте первого пациента',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: patients.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == patients.length) {
          return _buildLoadMoreButton(viewModel);
        }

        final patient = patients[index];
        return PatientCard(patient: patient);
      },
    );
  }


  Widget _buildLoadMoreButton(PatientSearchViewModel viewModel) {
    if (!viewModel.hasMore) {
      if (viewModel.displayedPatients.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'Загружено ${viewModel.displayedPatients.length} пациентов',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    if (viewModel.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Загрузка...', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: ElevatedButton(
          onPressed: () => viewModel.loadMorePatients(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand_40 ,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Загрузить ещё',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}