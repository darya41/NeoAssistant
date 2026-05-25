import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/add_patient_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../view_models/patient_search_viewmodel.dart';
import '../view_models/home_viewmodel.dart';
import '../view_models/protocol_search_viewmodel.dart';
import 'filter/filter_dialog.dart';

class SearchField extends StatefulWidget {
  final bool isGuest;
  final ProtocolSearchViewModel? protocolSearchViewModel;

  const SearchField({
    super.key,
    this.isGuest = false,
    this.protocolSearchViewModel,
  });

  @override
  State<SearchField> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void clearTextField() {
    _controller.clear();
  }


  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    return widget.isGuest
        ? _buildGuestSearch(context)
        : _buildAuthenticatedSearch(homeViewModel, context);
  }

  Widget _buildGuestSearch(BuildContext context) {
    final searchViewModel = widget.protocolSearchViewModel ?? context.watch<ProtocolSearchViewModel>();

    return Container(
      color: AppColors.brand_40,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(
              controller: _controller,
              hintText: 'Поиск по протоколам...',
              currentQuery: searchViewModel.searchQuery,
              onChanged: searchViewModel.search,
              onClear: () {
                _controller.clear();
                searchViewModel.clearSearch();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedSearch(HomeViewModel homeViewModel, BuildContext context) {
    final patientSearchViewModel = context.watch<PatientSearchViewModel>();
    final protocolSearchViewModel = widget.protocolSearchViewModel ?? context.watch<ProtocolSearchViewModel>();

    final isCardioeka = homeViewModel.isCardioeka;

    final currentQuery = isCardioeka
        ? patientSearchViewModel.searchQuery
        : protocolSearchViewModel.searchQuery;

    final hasActiveFilters = isCardioeka && patientSearchViewModel.hasActiveFilters;

    return Container(
      color: AppColors.brand_40,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(
              controller: _controller,
              hintText: isCardioeka
                  ? 'Поиск по номеру истории или ФИО матери'
                  : 'Поиск по протоколам, МКБ, диагностике, препаратам...',
              currentQuery: currentQuery,
              onChanged: (value) => isCardioeka
                  ? patientSearchViewModel.search(value)
                  : protocolSearchViewModel.search(value),
              onClear: () {
                _controller.clear();
                if (isCardioeka) {
                  patientSearchViewModel.clearSearch();
                } else {
                  protocolSearchViewModel.clearSearch();
                }
              },
              showFilterButton: isCardioeka,
              hasActiveFilters: hasActiveFilters,
              onFilterTap: () {
                showDialog(
                  context: context,
                  builder: (context) => FilterDialog(
                    viewModel: patientSearchViewModel,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          if (isCardioeka)
            _buildAddButton(context, patientSearchViewModel),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required String currentQuery,
    required Function(String) onChanged,
    required VoidCallback onClear,
    bool showFilterButton = false,
    bool hasActiveFilters = false,
    VoidCallback? onFilterTap,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          IconWidgets.searchIcon(onTap: () {}),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                suffixIcon: currentQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                )
                    : null,
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: onChanged,
            ),
          ),
          if (showFilterButton)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                children: [
                  IconWidgets.filterIcon(
                    onTap: onFilterTap ?? () {},
                  ),
                  if (hasActiveFilters)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, PatientSearchViewModel viewModel) {
    return Container(
      width: 38,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconWidgets.addIcon(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatientScreen()),
          ).then((_) {
            viewModel.refresh();
            _controller.clear();
          });
        },
      ),
    );
  }
}