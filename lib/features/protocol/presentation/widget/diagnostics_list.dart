import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/diagnostic_test.dart';
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
    final isLoadingMore = viewModel.isLoadingMore;
    final hasMore = viewModel.hasMore;
    final error = viewModel.error;

    return Column(
      children: [
        Expanded(
          child: _buildContent(
            viewModel,
            diagnostics,
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
      DiagnosticsViewModel viewModel,
      List<DiagnosticTest> diagnostics,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      String? error,
      ) {
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

    if (diagnostics.isEmpty) {
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