import 'package:flutter/material.dart';
import 'package:neo_friend/features/profile/presentation/pages/tech_level_screen.dart';
import 'about_screen.dart';

import '../view_models/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await _viewModel.showLogoutConfirmation(context);

    if (!confirmed) return;

    final success = await _viewModel.logout(context);

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingItem('О приложении', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            }),

            const SizedBox(height: 12),

            _buildSettingItem('Технологический уровень', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TechLevelScreen()),
              );
            }),

            const SizedBox(height: 200),
            _buildLogoutButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildVersionText(),
    );
  }

  Widget _buildSettingItem(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _viewModel.isLoggingOut ? null : _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(250, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: _viewModel.isLoggingOut
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Text('Выйти из аккаунта'),
      ),
    );
  }

  Widget _buildVersionText() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Center(
        child: Text(
          'Версия ${_viewModel.appVersion}',
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}