import 'package:flutter/material.dart';
import 'package:neo_friend/features/profile/presentation/pages/settings_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/patient.dart';
import '../../../../shared/widgets/block/patient_card.dart';
import '../../../auth/ presentation/pages/login_screen.dart';
import '../../../main/presentation/pages/home_screen.dart';
import '../../domain/entities/doctor.dart';
import '../../../main/presentation/widgets/navigation/custom_bottom_navigation_bar.dart';
import '../../../main/presentation/widgets/navigation/analytics_bottom_bar.dart';
import '../view_models/doctor_profile_viewmodel.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/guest_profile.dart';
import 'doctor_edit_profile_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final bool useAnalyticsBottomBar;
  final bool isGuest;

  const DoctorProfileScreen({
    super.key,
    this.useAnalyticsBottomBar = false,
    this.isGuest = false,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late final DoctorProfileViewModel _viewModel;
  final int _currentIndex = 3;

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

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToHomeAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(
          title: 'Главная',
          initialTab: 'Аналитика',
        ),
      ),
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
        actions: widget.isGuest
            ? []
            : [
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    if (widget.useAnalyticsBottomBar) {
      return AnalyticsBottomBar(
        currentIndex: _currentIndex,
        isGuest: widget.isGuest,
      );
    } else {
      return CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      );
    }
  }

  Widget _buildBody() {
    if (widget.isGuest) {
      return GuestProfile(
        onLoginPressed: _navigateToLogin,
        onContinueAsGuest: _navigateToHomeAsGuest,
      );
    }

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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DoctorInfoCard(doctor: _viewModel.doctor!),
          ),
          _buildFavoritesSection(),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Избранные:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFavoritePatientsList(),
        ],
      ),
    );
  }

  Widget _buildFavoritePatientsList() {
    return FutureBuilder<List<Patient>>(
      future: _viewModel.getFavoritePatients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  Text(
                    'Нет избранных пациентов',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        final patients = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          itemCount: patients.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final patient = patients[index];
            return _buildPatientCard(patient);
          },
        );
      },
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return PatientCard(
      patient: patient,
      showFavoriteIcon: true,
      isFavorite: true,
      onFavoriteTap: () {
        _viewModel.navigateToPatientDetails(context, patient);
      },
    );
  }
}