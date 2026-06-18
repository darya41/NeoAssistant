import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../view_model/registration_viewmodel.dart';
import '../widgets/registration_step1.dart';
import '../widgets/registration_step2.dart';
import '../widgets/registration_step3.dart';
import '../widgets/registration_step4.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RegistrationViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _handleNextStep() {
    _viewModel.nextStep();
  }

  void _handlePreviousStep() {
    if (_viewModel.currentStep > 0) {
      _viewModel.previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleRegistration() async {
    final success = await _viewModel.register();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация успешна! Теперь вы можете войти'),
          backgroundColor: AppColors.brand_40 ,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: AppColors.brand_40 ,
        leading: IconWidgets.backIcon(
          onTap: _handlePreviousStep,
          color: AppColors.neutral_0,
        ),
      ),
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_viewModel.currentStep) {
      case 0:
        return RegistrationStep1(
          emailController: _viewModel.emailController,
          passwordController: _viewModel.passwordController,
          confirmPasswordController: _viewModel.confirmPasswordController,
          onNextStep: _handleNextStep,
          isStepValid: _viewModel.isStep1Valid,
          emailError: _viewModel.emailError,
          passwordError: _viewModel.passwordError,
          confirmPasswordError: _viewModel.confirmPasswordError,
        );
      case 1:
        return RegistrationStep2(
          lastNameController: _viewModel.lastNameController,
          firstNameController: _viewModel.firstNameController,
          middleNameController: _viewModel.middleNameController,
          onNextStep: _handleNextStep,
          isStepValid: _viewModel.isStep2Valid,
        );
      case 2:
        return RegistrationStep3(
          phoneController: _viewModel.phoneController,
          onComplete: () {
            if (_viewModel.isStep3Valid) {
              _handleNextStep();
            }
          },
          isStepValid: _viewModel.isStep3Valid,
          phoneError: _viewModel.phoneError,
        );
      case 3:
        return RegistrationStep4(
          onComplete: _handleRegistration,
          onPositionSelected: _viewModel.selectPosition,
          selectedPositionId: _viewModel.selectedPositionId,
          isLoading: _viewModel.isLoading,
        );
      default:
        return Container();
    }
  }
}