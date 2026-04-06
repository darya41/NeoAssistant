import 'package:flutter/material.dart';
import '../../../../core/constants/filter.dart';
import '../view_models/patient_search_viewmodel.dart';
import 'filter_chip.dart';
import 'filter_section.dart';
import 'date_range_picker.dart';

class FilterDialog extends StatefulWidget {
  final PatientSearchViewModel viewModel;

  const FilterDialog({
    super.key,
    required this.viewModel,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? _tempGender;
  late String? _tempBloodGroup;
  late String? _tempRhFactor;
  late DateTimeRange? _tempDateRange;

  @override
  void initState() {
    super.initState();
    _tempGender = widget.viewModel.selectedGender;
    _tempBloodGroup = widget.viewModel.selectedBloodGroup;
    _tempRhFactor = widget.viewModel.selectedRhFactor;
    _tempDateRange = widget.viewModel.selectedDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Фильтры',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            FilterSection(
              title: 'Пол',
              child: _buildFilterChips(
                items: Filter.genders,
                selectedValue: _tempGender,
                onSelected: (value) {
                  setState(() {
                    _tempGender = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            FilterSection(
              title: 'Группа крови',
              child: _buildFilterChips(
                items: Filter.bloodGroups,
                selectedValue: _tempBloodGroup,
                onSelected: (value) {
                  setState(() {
                    _tempBloodGroup = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            FilterSection(
              title: 'Резус-фактор',
              child: _buildFilterChips(
                items: Filter.rhFactors,
                selectedValue: _tempRhFactor,
                onSelected: (value) {
                  setState(() {
                    _tempRhFactor = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            const FilterSection(
              title: 'Дата рождения',
              child: SizedBox.shrink(),
            ),
            DateRangePicker(
              selectedRange: _tempDateRange,
              onRangeSelected: (range) {
                setState(() {
                  _tempDateRange = range;
                });
              },
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Сбросить'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF44E4BF),
                    ),
                    child: const Text('Применить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips({
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final isSelected = selectedValue == item;
        return FilterChipWidget(
          label: item,
          isSelected: isSelected,
          onSelected: () {
            onSelected(isSelected ? null : item);
          },
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      _tempGender = null;
      _tempBloodGroup = null;
      _tempRhFactor = null;
      _tempDateRange = null;
    });
  }

  void _applyFilters() {
    widget.viewModel.setGenderFilter(_tempGender);
    widget.viewModel.setBloodGroupFilter(_tempBloodGroup);
    widget.viewModel.setRhFactorFilter(_tempRhFactor);
    widget.viewModel.setDateRangeFilter(_tempDateRange);
    Navigator.pop(context);
  }
}