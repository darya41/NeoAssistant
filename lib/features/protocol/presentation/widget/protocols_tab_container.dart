import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../main/presentation/view_models/protocol_search_viewmodel.dart';
import '../view_model/protocols_tab_viewmodel.dart';
import 'protocols_list.dart';
import 'mkb_categories_list.dart';
import 'medications_list.dart';
import 'diagnostics_list.dart';

class ProtocolsTabContainer extends StatelessWidget {
  final ProtocolSearchViewModel protocolSearchViewModel;

  const ProtocolsTabContainer({super.key, required this.protocolSearchViewModel,});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProtocolTabViewModel()),
        ChangeNotifierProvider.value(value: protocolSearchViewModel),
      ],
      child: const _ProtocolsTabContainerContent(),
    );
  }
}

class _ProtocolsTabContainerContent extends StatefulWidget {
  const _ProtocolsTabContainerContent();

  @override
  State<_ProtocolsTabContainerContent> createState() => _ProtocolsTabContainerContentState();
}

class _ProtocolsTabContainerContentState extends State<_ProtocolsTabContainerContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabViewModel = context.watch<ProtocolTabViewModel>();
    final searchViewModel = context.watch<ProtocolSearchViewModel>();
    final activeTab = tabViewModel.activeTab;

    if (searchViewModel.activeSearchTab != activeTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          searchViewModel.setActiveSearchTab(activeTab);
        }
      });
    }

    return Column(
      children: [
        _buildTabs(tabViewModel),
        Expanded(
          child: _buildContent(activeTab),
        ),
      ],
    );
  }

  Widget _buildTabs(ProtocolTabViewModel tabViewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutral_5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            label: 'Список',
            isSelected: tabViewModel.isListTab,
            onTap: () => _switchToTab('Список', tabViewModel.switchToListTab),
          ),
          _buildTab(
            label: 'МКБ',
            isSelected: tabViewModel.isMkbTab,
            onTap: () => _switchToTab('МКБ', tabViewModel.switchToMkbTab),
          ),
          _buildTab(
            label: 'Диагностика',
            isSelected: tabViewModel.isDiagnosticsTab,
            onTap: () => _switchToTab('Диагностика', tabViewModel.switchToDiagnosticsTab),
          ),
          _buildTab(
            label: 'Препараты',
            isSelected: tabViewModel.isMedicationsTab,
            onTap: () => _switchToTab('Препараты', tabViewModel.switchToMedicationsTab),
          ),
        ],
      ),
    );
  }

  void _switchToTab(String tab, VoidCallback switchTab) {
    switchTab();
    context.read<ProtocolSearchViewModel>().setActiveSearchTab(tab);
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              color: isSelected ? Colors.white : AppColors.neutral_90,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String activeTab) {
    switch (activeTab) {
      case 'Список':
        return const ProtocolsList();
      case 'МКБ':
        return const MkbCategoriesList();
      case 'Диагностика':
        return const DiagnosticsList();
      case 'Препараты':
        return const MedicationsList();
      default:
        return const SizedBox.shrink();
    }
  }
}