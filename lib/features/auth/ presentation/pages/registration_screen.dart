import 'package:flutter/material.dart';
import '../../../main/presentation/pages/home_screen.dart';
import '../widgets/registration_step1.dart';
import '../widgets/registration_step2.dart';
import '../widgets/registration_step3.dart';
import '../widgets/registration_step4.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/validators/auth_validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
 int? _selectedPositionId;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
    _confirmPasswordController.addListener(_updateState);
    _lastNameController.addListener(_updateState);
    _firstNameController.addListener(_updateState);
    _middleNameController.addListener(_updateState);
    _phoneController.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _confirmPasswordController.removeListener(_updateState);
    _lastNameController.removeListener(_updateState);
    _firstNameController.removeListener(_updateState);
    _middleNameController.removeListener(_updateState);
    _phoneController.removeListener(_updateState);

    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isStep1Valid {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!AuthValidator.isEmailValid(email)) return false;
    if (!AuthValidator.isPasswordValid(password)) return false;
    if (!AuthValidator.doPasswordsMatch(password, confirmPassword)) return false;

    return true;
  }

  bool get _isStep2Valid {
    return _lastNameController.text.trim().isNotEmpty &&
        _firstNameController.text.trim().isNotEmpty;
  }

  bool get _isStep3Valid {
    final digits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length == 12;
  }

  void _nextStep() {
    if (_currentStep == 0 && _isStep1Valid) {
      setState(() {
        _currentStep = 1;
      });
    } else if (_currentStep == 1 && _isStep2Valid) {
      setState(() {
        _currentStep = 2;
      });
    } else if (_currentStep == 2 && _isStep3Valid) {
      setState(() {
        _currentStep = 3;
      });
    } else if (_currentStep == 3 && _selectedPositionId != null) {
      _completeRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _completeRegistration() async {
    String phoneDigits = _phoneController.text
        .replaceAll(RegExp(r'[^\d]'), '')
        .substring(3);

    setState(() => _isLoading = true);

    try {
      final result = await _authRepository.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        lastName: _lastNameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim().isEmpty
            ? null
            : _middleNameController.text.trim(),
        phone: '+375$phoneDigits',
        positionId: _selectedPositionId!,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Регистрация успешна! Теперь вы можете войти'),
            backgroundColor: Color(0xFF44E4BF),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  void _onPositionSelected(int position) {
    setState(() {
      _selectedPositionId = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: const Color(0xFF44E4BF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _previousStep,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentStep) {
      case 0:
        return RegistrationStep1(
          emailController: _emailController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          onNextStep: _nextStep,
          isStepValid: _isStep1Valid,
        );
      case 1:
        return RegistrationStep2(
          lastNameController: _lastNameController,
          firstNameController: _firstNameController,
          middleNameController: _middleNameController,
          onNextStep: _nextStep,
          isStepValid: _isStep2Valid,
        );
      case 2:
        return RegistrationStep3(
          phoneController: _phoneController,
          onComplete: () {
            if (_isStep3Valid) {
              _nextStep();
            }
          },
          isStepValid: _isStep3Valid,
        );
      case 3:
        return RegistrationStep4(
          onComplete: _completeRegistration,
          onPositionSelected: _onPositionSelected,
        );
      default:
        return Container();
    }
  }
}