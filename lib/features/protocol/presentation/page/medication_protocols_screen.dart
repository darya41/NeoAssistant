import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_model/medication_protocols_viewmodel.dart';
import '../widget/protocol_card.dart';

class MedicationProtocolsScreen extends StatefulWidget {
  final int medicationId;
  final String medicationName;

  const MedicationProtocolsScreen({
    super.key,
    required this.medicationId,
    required this.medicationName,
  });

  @override
  State<MedicationProtocolsScreen> createState() => _MedicationProtocolsScreenState();
}

class _MedicationProtocolsScreenState extends State<MedicationProtocolsScreen> {
  late MedicationProtocolsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationProtocolsViewModel();
    _viewModel.loadProtocolsByMedication(widget.medicationId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Протоколы с препаратом "${widget.medicationName}"'),
          backgroundColor: AppColors.brand_40,
        ),
        body: Consumer<MedicationProtocolsViewModel>(
          builder: (context, viewModel, child) {
            return _buildContent(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildContent(MedicationProtocolsViewModel viewModel) {
    final items = viewModel.items;
    final isLoading = viewModel.isLoading;
    final error = viewModel.error;

    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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

    if (items.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication, size: 64, color: AppColors.neutral_25),
            const SizedBox(height: 16),
            Text(
              'Препарат "${widget.medicationName}" не используется в протоколах',
              style: TextStyle(fontSize: 16, color: AppColors.neutral_50),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!viewModel.isLoadingMore && viewModel.hasNext && !viewModel.isLoading) {
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
            final item = items[index];
            return ProtocolCard(item: item);
          },
        ),
      ),
    );
  }
}