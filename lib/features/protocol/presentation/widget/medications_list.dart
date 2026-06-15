import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../main/presentation/view_models/protocol_search_viewmodel.dart';
import '../view_model/medications_viewmodel.dart';
import 'medication_card.dart';

class MedicationsList extends StatefulWidget {
  final String? drugClass;

  const MedicationsList({super.key, this.drugClass});

  @override
  State<MedicationsList> createState() => _MedicationsListState();
}

class _MedicationsListState extends State<MedicationsList> {
  late MedicationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationsViewModel(
      searchQuery: '',
      drugClass: widget.drugClass,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final searchViewModel = context.watch<ProtocolSearchViewModel>();
    final currentQuery = searchViewModel.medicationsSearchQuery;

    if (_viewModel.currentSearchQuery != currentQuery) {
      _viewModel.updateSearchQuery(currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _MedicationsListContent(),
    );
  }
}

class _MedicationsListContent extends StatelessWidget {
  const _MedicationsListContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationsViewModel>(
      builder: (context, viewModel, child) {
        final items = viewModel.items;
        final isLoading = viewModel.isLoading;
        final error = viewModel.error;
        final searchQuery = viewModel.currentSearchQuery;

        if (isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Загрузка лекарств...'),
              ],
            ),
          );
        }

        if (error != null && items.isEmpty) {
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

        if (items.isEmpty && searchQuery.isNotEmpty && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Ничего не найдено по запросу "$searchQuery"',
                  style: TextStyle(fontSize: 16, color:AppColors.neutral_50),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (items.isEmpty && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medication, size: 64, color:AppColors.neutral_50),
                const SizedBox(height: 16),
                Text(
                  'Нет лекарственных препаратов',
                  style: TextStyle(fontSize: 16, color: AppColors.neutral_60),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (viewModel.hasNext && !viewModel.isLoading) {
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
              itemCount: items.length + (viewModel.hasNext ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final medication = items[index];
                return MedicationCard(medication: medication);
              },
            ),
          ),
        );
      },
    );
  }
}