import 'package:flutter/material.dart';
import '../../widgets/main/bottom_navigation_bar.dart';
import '../../widgets/main/doctor_profile_ui.dart';

class DoctorProfileScreen extends StatelessWidget {

  final Map<String, dynamic> _doctorData = {
    'position': 'Заместитель Главврача',
    'fullName': 'Елизавета Константиновна Константинопольская',
    'phone': '+375 (29) 333 33 33',
    'email': 'example.gmail.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: DoctorInfoCard(doctorData: _doctorData),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}
