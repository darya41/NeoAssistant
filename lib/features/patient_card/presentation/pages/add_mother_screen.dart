import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/address.dart';
import '../../../../models/mother.dart';
import '../../../../shared/widgets/buttons/save_button.dart';
import '../../data/repositories/address_repository.dart';
import '../../data/repositories/mother_repository.dart';
import '../widgets/mother_form.dart';

class AddMotherScreen extends StatefulWidget {
  const AddMotherScreen({super.key});

  @override
  State<AddMotherScreen> createState() => _AddMotherPageState();
}

class _AddMotherPageState extends State<AddMotherScreen> {
  final MotherRepository _motherRepository = MotherRepository();
  final AddressRepository _addressRepository = AddressRepository();

  Mother? _currentMother;
  Address? _currentAddress;
  bool _isSaving = false;
  bool _triedToSubmit = false;

  bool get _isFormValid {
    if (_currentMother == null) return false;
    return _currentMother!.lastName.isNotEmpty &&
        _currentMother!.firstName.isNotEmpty &&
        _currentMother!.bloodGroup != null &&
        _currentMother!.rhFactor != null;
  }

  bool _isAddressFilled(Address address) {
    return (address.city != null && address.city!.isNotEmpty) ||
        (address.street != null && address.street!.isNotEmpty) ||
        (address.houseNumber != null && address.houseNumber!.isNotEmpty) ||
        (address.building != null && address.building!.isNotEmpty) ||
        (address.apartment != null && address.apartment!.isNotEmpty);
  }

  bool _isAddressValid(Address address) {
    return (address.city != null && address.city!.isNotEmpty) &&
        (address.street != null && address.street!.isNotEmpty) &&
        (address.houseNumber != null && address.houseNumber!.isNotEmpty);
  }

  Future<void> _handleSave() async {
    setState(() => _triedToSubmit = true);

    if (!_isFormValid || _currentMother == null) {
      print('❌ Форма невалидна');
      return;
    }

    setState(() => _isSaving = true);

    try {
      int? savedAddressId;

      if (_currentAddress != null) {
        if (_isAddressFilled(_currentAddress!)) {
          if (_isAddressValid(_currentAddress!)) {
            final createdAddress = await _addressRepository.createAddress(_currentAddress!);
            savedAddressId = createdAddress.id;
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пожалуйста, заполните все поля адреса (город, улица, дом) или оставьте адрес пустым'),
                  backgroundColor: AppColors.error,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            setState(() => _isSaving = false);
            return;
          }
        }
      }

      final motherWithAddress = _currentMother!.copyWith(
        addressId: savedAddressId,
      );

      final createdMother = await _motherRepository.createMother(motherWithAddress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Мать успешно добавлена!'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context, createdMother);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
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
        backgroundColor: AppColors.white,
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
                  onAddressChanged: (address) {
                    setState(() {
                      _currentAddress = address;
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
                  bloodGroupError: _triedToSubmit && _currentMother?.bloodGroup == null
                      ? 'Группа крови обязательна'
                      : null,
                  rhFactorError: _triedToSubmit && _currentMother?.rhFactor == null
                      ? 'Резус-фактор обязателен'
                      : null,
                ),
              ),
            ),
            if (_isSaving)
              const Center(child: CircularProgressIndicator())
            else
              SaveButton(
                onPressed: _handleSave,
                backgroundColor: _isFormValid ? AppColors.primary : AppColors.background,
                borderColor: _isFormValid ? AppColors.primary : AppColors.border,
                textColor: _isFormValid ? AppColors.white : AppColors.black,
                isEnabled: _isFormValid,
              ),
          ],
        ),
      ),
    );
  }
}