import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/patient.dart';
import '../../../patient_card/presentation/pages/patient_details_screen.dart';
import '../view_models/patient_search_viewmodel.dart';

class PatientCards extends StatelessWidget {
  const PatientCards({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PatientSearchViewModel>();

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.refresh();
      },
      child: _buildContent(viewModel, context),
    );
  }

  Widget _buildContent(PatientSearchViewModel viewModel, BuildContext context) {
    final patients = viewModel.displayedPatients;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (viewModel.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (patients.isEmpty) {
      final isSearchMode = viewModel.searchQuery.isNotEmpty && viewModel.searchQuery.length >= 2;

      if (isSearchMode || viewModel.hasActiveFilters) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Ничего не найдено',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                isSearchMode
                    ? 'По запросу "${viewModel.searchQuery}" пациентов не найдено'
                    : 'По выбранным фильтрам пациентов не найдено',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (isSearchMode) {
                    viewModel.clearSearch();
                  } else {
                    viewModel.clearFilters();
                  }
                },
                child: const Text('Очистить'),
              ),
            ],
          ),
        );
      }

      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Нет пациентов',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте первого пациента',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: patients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return _buildPatientCard(context, patient, viewModel);
      },
    );
  }

  void _navigateToPatientDetails(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient, PatientSearchViewModel viewModel) {
    String displayGender = '';
    if (patient.gender == 'MALE') {
      displayGender = 'Мужской';
    } else if (patient.gender == 'FEMALE') {
      displayGender = 'Женский';
    } else {
      displayGender = patient.gender;
    }

    return InkWell(
      onTap: () => _navigateToPatientDetails(context, patient),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patient.numberHistory,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              patient.motherName ?? 'Пациент #${patient.patientId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDataColumn('Дата родов', _formatDate(patient.dateOfBirth)),
                const VerticalDivider(width: 1, color: Colors.grey),
                _buildDataColumn('Пол', displayGender),
                const VerticalDivider(width: 1, color: Colors.grey),
                _buildDataColumn('Г.К.', patient.formattedBloodType),
              ],
            ),
            const Divider(color: Colors.grey, thickness: 0.5, height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumn(String label, String value) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'Не указана';
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateTime;
    }
  }
}