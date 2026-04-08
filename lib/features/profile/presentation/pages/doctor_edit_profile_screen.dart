import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../data/repositories/profile_repository.dart';
import '../widgets/profile_form_fields.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorEditProfileScreen({super.key, required this.doctorData});

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileRepository _repository = ProfileRepository();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _patronymicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<Map<String, dynamic>> _specializations = [];
  int? _selectedSpecializationId;
  String? _currentSpecializationName;

  bool _isLoadingSpecializations = false;
  bool _isSaving = false;
  String? _specializationError;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _loadSpecializations();

    _lastNameController.text = widget.doctorData['lastName'] ?? '';
    _firstNameController.text = widget.doctorData['firstName'] ?? '';
    _patronymicController.text = widget.doctorData['patronymic'] ?? '';
    _emailController.text = widget.doctorData['email'] ?? '';
    _phoneController.text = widget.doctorData['phone'] ?? '';

    _currentSpecializationName = widget.doctorData['specialization'] ?? '';
  }

  Future<void> _loadSpecializations() async {
    setState(() {
      _isLoadingSpecializations = true;
      _specializationError = null;
    });

    try {
      print('Specializations ');
      final specializations = await ApiClient.get('specializations');

      print('Specializations response: $specializations');

      setState(() {
        _specializations = List<Map<String, dynamic>>.from(specializations);
        _isLoadingSpecializations = false;

        if (_currentSpecializationName != null && _currentSpecializationName!.isNotEmpty) {
          final matchingSpec = _specializations.firstWhere(
                (spec) => spec['name'] == _currentSpecializationName,
            orElse: () => {},
          );
          if (matchingSpec.isNotEmpty) {
            _selectedSpecializationId = matchingSpec['specialization_id'];
          }
        }
      });
    } catch (e) {
      print('Error loading specializations: $e');
      setState(() {
        _specializationError = 'Ошибка загрузки должностей: ${e.toString().replaceFirst('Exception: ', '')}';
        _isLoadingSpecializations = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_isFormValid()) return;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      final response = await _repository.updateProfile(
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        patronymic: _patronymicController.text.isNotEmpty
            ? _patronymicController.text
            : null,
        email: _emailController.text,
        phone: _phoneController.text,
        specializationId: _selectedSpecializationId!,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль успешно обновлён'),
            backgroundColor: Color(0xFF44E4BF),
          ),
        );
        Navigator.pop(context, response['doctor']);
      }
    } catch (e) {
      setState(() {
        _saveError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  bool _isFormValid() {
    if (_lastNameController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedSpecializationId == null) {
      return false;
    }

    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6) return false;
      if (_passwordController.text != _confirmPasswordController.text) return false;
    }

    return true;
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _patronymicController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _isFormValid();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_saveError != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _saveError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileFormFields(
                        lastNameController: _lastNameController,
                        firstNameController: _firstNameController,
                        patronymicController: _patronymicController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        phoneController: _phoneController,
                      ),
                      const SizedBox(height: 16),
                      _buildSpecializationDropdown(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isSaving)
                const Center(child: CircularProgressIndicator())
              else
                ContinueButton(
                  onPressed: isFormValid ? _saveChanges : null,
                  isEnabled: isFormValid,
                  text: 'Сохранить изменения',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecializationDropdown() {
    if (_isLoadingSpecializations) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_specializationError != null) {
      return Column(
        children: [
          Text(
            _specializationError!,
            style: const TextStyle(color: Colors.red),
          ),
          TextButton(
            onPressed: _loadSpecializations,
            child: const Text('Повторить'),
          ),
        ],
      );
    }

    if (_specializations.isEmpty) {
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
            value: _selectedSpecializationId,
            hint: Text(_currentSpecializationName ?? 'Выберите должность'),
            items: _specializations.map((spec) {
              return DropdownMenuItem<int>(
                value: spec['specialization_id'],
                child: Text(spec['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSpecializationId = value;
              });
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