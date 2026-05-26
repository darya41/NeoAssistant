import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../main/presentation/view_models/protocol_search_viewmodel.dart';
import '../view_model/protocol_list_viewmodel.dart';
import 'protocol_card.dart';

class ProtocolsList extends StatefulWidget {
  const ProtocolsList({super.key});

  @override
  State<ProtocolsList> createState() => _ProtocolsListState();
}

class _ProtocolsListState extends State<ProtocolsList> {
  late ProtocolListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProtocolListViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final searchViewModel = context.watch<ProtocolSearchViewModel>();
    final currentQuery = searchViewModel.protocolSearchQuery;

    if (_viewModel.currentSearchQuery != currentQuery) {
      _viewModel.updateSearchQuery(currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _ProtocolsListContent(),
    );
  }
}

class _ProtocolsListContent extends StatelessWidget {
  const _ProtocolsListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProtocolListViewModel>();

    return Expanded(
      child: _buildContent(viewModel),
    );
  }

  Widget _buildContent(ProtocolListViewModel viewModel) {
    if (viewModel.isLoading && viewModel.items.isEmpty) {
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

    if (viewModel.error != null && viewModel.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Ошибка: $viewModel.error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (viewModel.items.isEmpty && !viewModel.isLoading) {
      if (viewModel.isSearching) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Ничего не найдено по запросу "$viewModel.searchQuery"',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.updateSearchQuery(''),
                child: const Text('Очистить поиск'),
              ),
            ],
          ),
        );
      }

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
        itemCount: viewModel.items.length,
        itemBuilder: (context, index) {
          return ProtocolCard(item: viewModel.items[index]);
        },
      ),
    );
  }
}