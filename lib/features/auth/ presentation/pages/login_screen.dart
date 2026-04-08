import 'package:flutter/material.dart';
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
      onCreateAccountPressed: _navigateToRegistration,
      errorMessage: _viewModel.errorMessage,
      isLoading: _viewModel.isLoading,
      isFormValid: _viewModel.isFormValid,
    );
  }
}