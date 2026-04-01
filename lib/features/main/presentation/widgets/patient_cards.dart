import 'package:flutter/material.dart';
import '../../../../models/patient.dart';
import '../../../patient_card/presentation/pages/patient_details_screen.dart';
import '../../data/repository/patient_service.dart';

class PatientCards extends StatefulWidget {
  const PatientCards({super.key});

  @override
  State<PatientCards> createState() => _PatientCardsState();
}

class _PatientCardsState extends State<PatientCards> {
  List<Patient> _patients = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patients = await PatientService.getPatients();
      setState(() {
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPatients() async {
    await _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshPatients,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_patients.isEmpty) {
      return const Center(
        child: Text('Нет пациентов'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPatients,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: _patients.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return _buildPatientCard(patient);
        },
      ),
    );
  }
  void _navigateToPatientDetails(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(
          patient: patient,
        ),
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return InkWell(
      onTap: () => _navigateToPatientDetails(patient),
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

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

  String _formatGender(String gender) {
    if (gender == 'MALE' || gender == 'M') {
      return 'Мужской';
    } else if (gender == 'FEMALE' || gender == 'F') {
      return 'Женский';
    }
    return gender;
  }
}