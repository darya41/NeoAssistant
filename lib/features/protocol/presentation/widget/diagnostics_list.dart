import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../main/presentation/view_models/protocol_search_viewmodel.dart';
import '../view_model/diagnostics_viewmodel.dart';
import 'diagnostic_card.dart';

class DiagnosticsList extends StatefulWidget {
  const DiagnosticsList({super.key});

  @override
  State<DiagnosticsList> createState() => _DiagnosticsListState();
}

class _DiagnosticsListState extends State<DiagnosticsList> {
  late DiagnosticsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DiagnosticsViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final searchViewModel = context.watch<ProtocolSearchViewModel>();
    final currentQuery = searchViewModel.diagnosticsSearchQuery;

    if (_viewModel.currentSearchQuery != currentQuery) {
      _viewModel.updateSearchQuery(currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _DiagnosticsListContent(),
    );
  }
}

class _DiagnosticsListContent extends StatelessWidget {
  const _DiagnosticsListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DiagnosticsViewModel>();
    final diagnostics = viewModel.diagnostics;
    final isLoading = viewModel.isLoading;
    final isLoadingMore = viewModel.isLoadingMore;
    final hasMore = viewModel.hasMore;
    final error = viewModel.error;
    final searchQuery = viewModel.currentSearchQuery;

    if (isLoading && diagnostics.isEmpty) {
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

    if (error != null && diagnostics.isEmpty) {
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

    if (diagnostics.isEmpty && searchQuery.isNotEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено по запросу "$searchQuery"',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (diagnostics.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет диагностических исследований',
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
          itemCount: diagnostics.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == diagnostics.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final diagnostic = diagnostics[index];
            return DiagnosticCard(diagnostic: diagnostic);
          },
        ),
      ),
    );
  }
}