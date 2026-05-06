import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/guest_service.dart';
import '../view_model/login_viewmodel.dart';
import '../widgets/login_ui.dart';
import '../../../main/presentation/pages/home_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleLogin() async {
    final success = await _viewModel.login(context);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Neo Friend - Главная'),
        ),
      );
    }
  }

  Future<void> _handleGuestLogin() async {
    try {
      await GuestService.loginAsGuest();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(title: 'Neo Friend - Главная'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка входа как гость: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _navigateToRegistration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginUI(
      emailController: _viewModel.emailController,
      passwordController: _viewModel.passwordController,
      onLoginPressed: _handleLogin,
      onGuestLoginPressed: _handleGuestLogin,
      onCreateAccountPressed: _navigateToRegistration,
      errorMessage: _viewModel.errorMessage,
      isLoading: _viewModel.isLoading,
      isFormValid: _viewModel.isFormValid,
      onClearError: _viewModel.clearError,
    );
  }
}