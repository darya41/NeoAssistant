import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_model/diagnostics_viewmodel.dart';
import 'diagnostic_card.dart';

class DiagnosticsList extends StatelessWidget {
  const DiagnosticsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosticsViewModel(),
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
    final error = viewModel.error;
    final hasMore = viewModel.hasMore;
    final isSearching = viewModel.isSearching;

    return Column(
      children: [

        Expanded(
          child: _buildContent(
            context,
            viewModel,
            diagnostics,
            isLoading,
            error,
            hasMore,
            isSearching,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context,
      DiagnosticsViewModel viewModel,
      List<dynamic> diagnostics,
      bool isLoading,
      String? error,
      bool hasMore,
      bool isSearching,
      ) {
    if (isLoading && diagnostics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && diagnostics.isEmpty) {
      return _buildErrorWidget(error, viewModel);
    }

    if (diagnostics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Ничего не найдено' : 'Нет диагностических исследований',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.clearSearch(),
                child: const Text('Очистить поиск'),
              ),
            ],
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isLoading && hasMore && !isSearching) {
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
        itemCount: diagnostics.length + (hasMore && !isSearching ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
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
    );
  }

  Widget _buildErrorWidget(String error, DiagnosticsViewModel viewModel) {
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