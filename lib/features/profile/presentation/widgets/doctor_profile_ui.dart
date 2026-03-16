import 'package:flutter/material.dart';

class DoctorInfoCard extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const DoctorInfoCard({
    super.key,
    required this.doctorData,
  });


  @override
  Widget build(BuildContext context) {
    final specialization = doctorData['specialization'] ??
        'Должность не указана';

    final fullName = [
      doctorData['lastName'],
      doctorData['firstName'],
      doctorData['patronymic']
    ].where((name) => name != null && name.isNotEmpty)
        .join(' ');

    final displayName = fullName.isNotEmpty ? fullName : 'Имя не указано';

    final phone = doctorData['phone'] ??
        'Телефон не указан';

    final email = doctorData['email'] ??
        'Email не указан';


    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE5FFF9),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            specialization,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            displayName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            phone,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
