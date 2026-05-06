import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/add_patient_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../view_models/patient_search_viewmodel.dart';
import '../view_models/protocol_search_viewmodel.dart';
import '../view_models/home_viewmodel.dart';
import 'filter/filter_dialog.dart';

class SearchField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final bool isGuest;

  SearchField({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    if (isGuest) {
      return _buildGuestSearch(homeViewModel, context);
    }

    return _buildAuthenticatedSearch(homeViewModel, context);
  }

  Widget _buildGuestSearch(HomeViewModel homeViewModel, BuildContext context) {
    final protocolViewModel = context.watch<ProtocolSearchViewModel>();

    return Container(
      color: AppColors.brand_40,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Поиск по протоколам...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            protocolViewModel.clearSearch();
                          },
                        )
                            : null,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        protocolViewModel.searchProtocols(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedSearch(HomeViewModel homeViewModel, BuildContext context) {
    final patientViewModel = context.watch<PatientSearchViewModel>();
    final protocolViewModel = context.watch<ProtocolSearchViewModel>();

    final isCardioeka = homeViewModel.isCardioeka;

    final currentQuery = isCardioeka
        ? (patientViewModel.searchQuery)
        : (protocolViewModel.searchQuery);

    final hasActiveFilters = isCardioeka && (patientViewModel.hasActiveFilters);

    return Container(
      color: AppColors.brand_40,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: isCardioeka
                            ? 'Поиск по номеру истории или ФИО матери'
                            : 'Поиск по протоколам...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: currentQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            if (isCardioeka) {
                              patientViewModel.clearSearch();
                            } else {
                              protocolViewModel.clearSearch();
                            }
                          },
                        )
                            : null,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        if (isCardioeka) {
                          patientViewModel.search(value);
                        } else {
                          protocolViewModel.searchProtocols(value);
                        }
                      },
                    ),
                  ),
                  if (isCardioeka)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          IconWidgets.filterIcon(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => FilterDialog(
                                  viewModel: patientViewModel,
                                ),
                              );
                            },
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
            ),
          ),
          const SizedBox(width: 12),

          if (isCardioeka)
            Container(
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
                    patientViewModel.refresh();
                    _controller.clear();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}