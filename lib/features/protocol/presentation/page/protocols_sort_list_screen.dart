import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_model/protocols_sort_list_viewmodel.dart';
import '../widget/protocol_card.dart';

enum ProtocolsSourceType {
  medication,
  diagnostic,
  mkb,
}

class ProtocolsSortListScreen extends StatefulWidget {
  final int sourceId;
  final String sourceName;
  final ProtocolsSourceType sourceType;
  final int? techLevelId; // Добавляем параметр

  const ProtocolsSortListScreen({
    super.key,
    required this.sourceId,
    required this.sourceName,
    required this.sourceType,
    this.techLevelId, // Добавляем
  });

  @override
  State<ProtocolsSortListScreen> createState() => _ProtocolsSortListScreenState();
}

class _ProtocolsSortListScreenState extends State<ProtocolsSortListScreen> {
  late ProtocolsSortListViewmodel _viewModel;

  @override
  void initState() {
    super.initState();
    // Передаем techLevelId в ViewModel
    _viewModel = ProtocolsSortListViewmodel(techLevelId: widget.techLevelId);
    _loadProtocols();
  }

  void _loadProtocols() {
    switch (widget.sourceType) {
      case ProtocolsSourceType.medication:
        _viewModel.loadProtocolsByMedication(widget.sourceId);
        break;
      case ProtocolsSourceType.diagnostic:
        _viewModel.loadProtocolsByDiagnostic(widget.sourceId);
        break;
      case ProtocolsSourceType.mkb:
        _viewModel.loadProtocolsByMkb(widget.sourceId);
        break;
    }
  }

  String _getTitle() {
    switch (widget.sourceType) {
      case ProtocolsSourceType.medication:
        return 'Протоколы с препаратом "${widget.sourceName}"';
      case ProtocolsSourceType.diagnostic:
        return 'Протоколы с исследованием "${widget.sourceName}"';
      case ProtocolsSourceType.mkb:
        return 'Протоколы с кодом МКБ "${widget.sourceName}"';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          backgroundColor: AppColors.brand_40,
        ),
        body: Consumer<ProtocolsSortListViewmodel>(
          builder: (context, viewModel, child) {
            return _buildContent(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildContent(ProtocolsSortListViewmodel viewModel) {
    final items = viewModel.items;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;

    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && items.isEmpty) {
      return _buildErrorWidget(viewModel);
    }

    if (items.isEmpty && !isLoading) {
      return _buildEmptyWidget();
    }

    return _buildListView(viewModel);
  }

  Widget _buildErrorWidget(ProtocolsSortListViewmodel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Ошибка: ${viewModel.error}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.refresh(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    IconData icon;
    String message;

    switch (widget.sourceType) {
      case ProtocolsSourceType.medication:
        icon = Icons.medication;
        message = 'Препарат "${widget.sourceName}" не используется в протоколах';
        break;
      case ProtocolsSourceType.diagnostic:
        icon = Icons.medical_information;
        message = 'Исследование "${widget.sourceName}" не используется в протоколах';
        break;
      case ProtocolsSourceType.mkb:
        icon = Icons.code;
        message = 'Код МКБ "${widget.sourceName}" не используется в протоколах';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.neutral_25),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: AppColors.neutral_50),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(ProtocolsSortListViewmodel viewModel) {
    final items = viewModel.items;
    final hasNext = viewModel.hasNext;
    final isLoadingMore = viewModel.isLoadingMore;
    final isLoading = viewModel.isLoading;

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoadingMore && hasNext && !isLoading) {
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
          itemCount: items.length + (hasNext ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return ProtocolCard(item: items[index]);
          },
        ),
      ),
    );
  }
}