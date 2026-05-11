import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/protocol_list_item.dart';
import '../view_model/protocol_list_viewmodel.dart';
import 'protocol_card.dart';

class ProtocolsList extends StatelessWidget {
  const ProtocolsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProtocolListViewModel(),
      child: const _ProtocolsListContent(),
    );
  }
}

class _ProtocolsListContent extends StatelessWidget {
  const _ProtocolsListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProtocolListViewModel>();
    final items = viewModel.items;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;

    return Column(
      children: [
        Expanded(
          child: _buildContent(viewModel, items, isLoading, error),
        ),
      ],
    );
  }

  Widget _buildContent(
      ProtocolListViewModel viewModel,
      List<ProtocolListItem> items,
      bool isLoading,
      String? error,
      ) {
    if (isLoading && items.isEmpty) {
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

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Нет данных'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ProtocolCard(item: item);
        },
      ),
    );
  }
}