import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neo_friend/features/patient_card/presentation/pages/add_patient_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../view_models/patient_search_viewmodel.dart';
import 'filter_dialog.dart';

class SearchField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PatientSearchViewModel>();

    return Container(
      color: AppColors.primary,
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
                        hintText: 'Поиск по номеру истории или ФИО матери',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: viewModel.searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            viewModel.clearSearch();
                          },
                        )
                            : null,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        viewModel.search(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        IconWidgets.filterIcon(
                          onTap: () {
                            final viewModel = context.read<PatientSearchViewModel>();
                            showDialog(
                              context: context,
                              builder: (context) => FilterDialog(
                                viewModel: viewModel,
                              ),
                            );
                          },
                        ),
                        if (viewModel.hasActiveFilters)
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
                  viewModel.refresh();
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