import 'package:flutter/material.dart';
import 'package:neo_friend/features/profile/presentation/pages/settings_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/doctor.dart';
import '../../../main/presentation/widgets/navigation/custom_bottom_navigation_bar.dart';
import '../view_models/doctor_profile_viewmodel.dart';
import '../widgets/doctor_info_card.dart';
import 'doctor_edit_profile_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late final DoctorProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DoctorProfileViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleEdit() async {
    if (_viewModel.doctor == null) return;

    final updatedDoctor = await Navigator.push<Doctor>(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorEditProfileScreen(
          doctor: _viewModel.doctor!,
        ),
      ),
    );

    if (updatedDoctor != null) {
      _viewModel.updateDoctor(updatedDoctor);
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF44E4BF),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _navigateToSettings,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _handleEdit,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _viewModel.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _viewModel.retry(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Повторить',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_viewModel.doctor == null) {
      return const Center(child: Text('Нет данных'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DoctorInfoCard(doctor: _viewModel.doctor!),
    );
  }
}