import 'package:flutter/material.dart';

class DoctorInfoCard extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const DoctorInfoCard({
    super.key,
    required this.doctorData,
  });

  @override
  Widget build(BuildContext context) {
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
            doctorData['position'],
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            doctorData['fullName'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            doctorData['phone'],
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            doctorData['email'],
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
