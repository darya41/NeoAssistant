import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.error != null && !viewModel.hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewModel.error!,
              style: const TextStyle(color: Colors.red),
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

    if (!viewModel.hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_information, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Пациенты не найдены',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.searchQuery.isNotEmpty
                  ? 'Попробуйте изменить поисковый запрос'
                  : 'Добавьте первого пациента',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: viewModel.patients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final patient = viewModel.patients[index];
        return _buildPatientCard(context, patient);
      },
    );
  }

  void _navigateToPatientDetails(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(
          patient: patient,
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    return InkWell(
      onTap: () => _navigateToPatientDetails(context, patient),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(patient),
            const SizedBox(height: 16),
            _buildPatientName(patient.motherName ?? 'Пациент #${patient.patientId}'),
            const SizedBox(height: 16),
            _buildPatientDataRow(
              _formatDate(patient.dateOfBirth),
              _formatGender(patient.gender),
              patient.formattedBloodType,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Patient patient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          patient.numberHistory,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientName(String patientName) {
    return Text(
      patientName,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPatientDataRow(String birthDate, String gender, String bloodType) {
    return Row(
      children: [
        _buildDataColumn('Дата родов', birthDate),
        const VerticalDivider(width: 1, color: Colors.grey),
        _buildDataColumn('Пол', gender),
        const VerticalDivider(width: 1, color: Colors.grey),
        _buildDataColumn('Г.К.', bloodType),
      ],
    );
  }

  Widget _buildDataColumn(String label, String value) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null) return 'Не указана';
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateTime;
    }
  }

  String _formatGender(String? gender) {
    if (gender == 'MALE' || gender == 'M') {
      return 'Мужской';
    } else if (gender == 'FEMALE' || gender == 'F') {
      return 'Женский';
    }
    return gender ?? 'Не указан';
  }
}