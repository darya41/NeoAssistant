import 'package:flutter/material.dart';
import '../../../../models/mother.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../widgets/mother_form.dart';

class AddMotherScreen extends StatefulWidget {
  const AddMotherScreen({super.key});

  @override
  State<AddMotherScreen> createState() => _AddMotherPageState();
}

class _AddMotherPageState extends State<AddMotherScreen> {

  Mother? _currentMother;
  bool _isSaving = false;
  bool _triedToSubmit = false;

  bool get _isFormValid {
    if (_currentMother == null) return false;
    return _currentMother!.lastName.isNotEmpty &&
        _currentMother!.firstName.isNotEmpty &&
        _currentMother!.dateOfBirth != null;
  }

  Future<void> _handleSave() async {
    setState(() => _triedToSubmit = true);

    if (!_isFormValid || _currentMother == null) return;

    setState(() => _isSaving = true);

    try {
      // создание матери
      // переход обратно с сохранненой матерью  Navigator.pop(context, created);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить мать'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: MotherFormWidget(
                  onMotherChanged: (mother) {
                    setState(() {
                      _currentMother = mother;
                    });
                  },
                  showValidationErrors: _triedToSubmit,
                  lastNameError: _triedToSubmit && _currentMother?.lastName.isEmpty == true
                      ? 'Фамилия обязательна'
                      : null,
                  firstNameError: _triedToSubmit && _currentMother?.firstName.isEmpty == true
                      ? 'Имя обязательно'
                      : null,
                  dateError: _triedToSubmit && _currentMother?.dateOfBirth == null
                      ? 'Дата рождения обязательна'
                      : null,
                ),
              ),
            ),
            if (_isSaving)
              const Center(child: CircularProgressIndicator())
            else
              SaveButton(
                onPressed: _handleSave,
                backgroundColor: _isFormValid ? const Color(0xFF44E4BF) : const Color(0xFFF3F3F3),
                borderColor: _isFormValid ? const Color(0xFF44E4BF) : const Color(0xFFC6C6C6),
                textColor: _isFormValid ? Colors.white : Colors.black,
                isEnabled: _isFormValid,
              ),
          ],
        ),
      ),
    );
  }
}