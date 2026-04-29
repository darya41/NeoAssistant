import 'package:flutter/material.dart';
import '../../../features/patient_card/presentation/pages/patient_details_screen.dart';
import '../../../models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final bool showFavoriteIcon;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const PatientCard({
    super.key,
    required this.patient,
    this.showFavoriteIcon = false,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
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
                if (showFavoriteIcon)
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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

  void _navigateToPatientDetails(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
      ),
    );
  }
}