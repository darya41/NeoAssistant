import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_model/protocol_search_viewmodel.dart';
import 'mkb_categories_list.dart';
import 'medications_list.dart';
import 'protocols_list.dart';
import 'diagnostics_list.dart';

class ProtocolsTabContainer extends StatelessWidget {
  const ProtocolsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabs(context),
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final viewModel = context.watch<ProtocolSearchViewModel>();

    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            context: context,
            label: 'Список',
            isSelected: viewModel.isListTab,
          ),
          _buildTab(
            context: context,
            label: 'МКБ',
            isSelected: viewModel.isMkbTab,
          ),
          _buildTab(
            context: context,
            label: 'Диагностика',
            isSelected: viewModel.isDiagnosticsTab,
          ),
          _buildTab(
            context: context,
            label: 'Препараты',
            isSelected: viewModel.isMedicationsTab,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
        onTap: () {
          final viewModel = context.read<ProtocolSearchViewModel>();
          if (label == 'Список') {
            viewModel.switchToListTab();
          } else if (label == 'МКБ') {
            viewModel.switchToMkbTab();
          } else if (label == 'Диагностика') {
            viewModel.switchToDiagnosticsTab();
          } else if (label == 'Препараты') {
            viewModel.switchToMedicationsTab();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brand_40 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final viewModel = context.watch<ProtocolSearchViewModel>();
    final activeTab = viewModel.activeTab;

    if (activeTab == 'Список') {
      return const ProtocolsList();
    } else if (activeTab == 'МКБ') {
      return const MkbCategoriesList();
    } else if (activeTab == 'Диагностика') {
      return const DiagnosticsList();
    } else {
      return const MedicationsList();
    }
  }
}