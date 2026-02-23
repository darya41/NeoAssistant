import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientCards extends StatelessWidget {
  const PatientCards({super.key});

  static const List<Map<String, dynamic>> _patientsData = [
    {
      'cardNumber': '035231412432355532',
      'status': 'Архив',
      'patientName': 'Елизавета Константиновна Константинопольская',
      'birthDate': '03/05/2025 14:30',
      'gender': 'Мужской',
      'bloodType': 'A (II), Rh–',
      'hasConcern': false,
    },
    {
      'cardNumber': '035231412432355532',
      'status': 'Архив',
      'patientName': 'Сидорова Татьяна Викторовна',
      'birthDate': '03/05/2025 14:30',
      'gender': 'Мужской',
      'bloodType': 'A (II), Rh–',
      'hasConcern': false,
    },
    {
      'cardNumber': '035231441243235535',
      'status': 'Архив',
      'patientName': 'Смирнова Анна Валентиновна',
      'birthDate': '03/05/2025 14:30',
      'gender': 'Женский',
      'bloodType': 'B (III), Rh+',
      'hasConcern': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: _patientsData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final patient = Patient.fromMap(_patientsData[index]);
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return InkWell(
      onTap: () {
        // Обработчик нажатия на карточку пациента
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(patient),
            const SizedBox(height: 16),
            _buildPatientName(patient.patientName),
            const SizedBox(height: 16),
            _buildPatientDataRow(
                patient.birthDate,
                patient.gender,
                patient.bloodType
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
          patient.cardNumber,
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
}