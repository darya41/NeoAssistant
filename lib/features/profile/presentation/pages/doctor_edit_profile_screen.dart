import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/doctor.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../../auth/ presentation/widgets/error_container.dart';
import '../view_models/doctor_edit_profile_viewmodel.dart';
import '../widgets/profile_form_fields.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorEditProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  late final DoctorEditProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DoctorEditProfileViewModel(widget.doctor);
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleSave() async {
    final updatedDoctor = await _viewModel.saveChanges();

    if (updatedDoctor != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Профиль успешно обновлён'),
          backgroundColor: Color(0xFF44E4BF),
        ),
      );
      Navigator.pop(context, updatedDoctor);
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
        title: const Text('Редактирование профиля'),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            ErrorContainer(errorMessage: _viewModel.saveError),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileFormFields(
                      lastNameController: _viewModel.lastNameController,
                      firstNameController: _viewModel.firstNameController,
                      patronymicController: _viewModel.patronymicController,
                      emailController: _viewModel.emailController,
                      passwordController: _viewModel.passwordController,
                      confirmPasswordController: _viewModel.confirmPasswordController,
                      phoneController: _viewModel.phoneController,
                      isEmailEditable: false,
                      emailError: _viewModel.emailError,
                      passwordError: _viewModel.passwordError,
                      confirmPasswordError: _viewModel.confirmPasswordError,
                    ),
                    const SizedBox(height: 16),
                    _buildSpecializationDropdown(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_viewModel.isSaving)
              const Center(child: CircularProgressIndicator())
            else
              ContinueButton(
                onPressed: _viewModel.isFormValid ? _handleSave : null,
                isEnabled: _viewModel.isFormValid,
                text: 'Сохранить изменения',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationDropdown() {
    if (_viewModel.isLoadingSpecializations) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.specializationError != null) {
      return Column(
        children: [
          Text(
            _viewModel.specializationError!,
            style: const TextStyle(color: AppColors.error),
          ),
          TextButton(
            onPressed: () => _viewModel.loadSpecializations(),
            child: const Text('Повторить'),
          ),
        ],
      );
    }

    if (_viewModel.specializations.isEmpty) {
      return const Text('Нет доступных должностей');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Должность',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<int>(
            value: _viewModel.selectedSpecializationId,
            hint: Text(_viewModel.currentSpecializationName ?? 'Выберите должность'),
            items: _viewModel.specializations.map((spec) {
              return DropdownMenuItem<int>(
                value: spec.id,
                child: Text(spec.name),
              );
            }).toList(),
            onChanged: (value) {
              _viewModel.selectSpecialization(value);
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}