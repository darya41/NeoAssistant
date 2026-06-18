import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/mother.dart';
import '../../data/repositories/address_repository.dart';
import '../../data/repositories/mother_repository.dart';

class AddMotherViewModel extends ChangeNotifier {
  final MotherRepository _motherRepository = MotherRepository();
  final AddressRepository _addressRepository = AddressRepository();

  Mother? _currentMother;
  Address? _currentAddress;
  bool _isSaving = false;
  bool _triedToSubmit = false;

  Mother? get currentMother => _currentMother;
  Address? get currentAddress => _currentAddress;
  bool get isSaving => _isSaving;
  bool get triedToSubmit => _triedToSubmit;

  bool get isFormValid {
    if (_currentMother == null) return false;
    return _currentMother!.lastName.isNotEmpty &&
        _currentMother!.firstName.isNotEmpty &&
        _currentMother!.bloodGroup != null &&
        _currentMother!.rhFactor != null;
  }

  String? get lastNameError {
    if (!_triedToSubmit) return null;
    return _currentMother?.lastName.isEmpty == true ? 'Фамилия обязательна' : null;
  }

  String? get firstNameError {
    if (!_triedToSubmit) return null;
    return _currentMother?.firstName.isEmpty == true ? 'Имя обязательно' : null;
  }

  String? get dateError {
    if (!_triedToSubmit) return null;
    return _currentMother?.dateOfBirth == null ? 'Дата рождения обязательна' : null;
  }

  String? get bloodGroupError {
    if (!_triedToSubmit) return null;
    return _currentMother?.bloodGroup == null ? 'Группа крови обязательна' : null;
  }

  String? get rhFactorError {
    if (!_triedToSubmit) return null;
    return _currentMother?.rhFactor == null ? 'Резус-фактор обязателен' : null;
  }

  void onMotherChanged(Mother mother) {
    _currentMother = mother;
    notifyListeners();
  }

  void onAddressChanged(Address? address) {
    _currentAddress = address;
    notifyListeners();
  }

  void onTriedToSubmit() {
    _triedToSubmit = true;
    notifyListeners();
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

  Future<Mother?> saveMother(BuildContext context) async {
    _isSaving = true;
    notifyListeners();

    try {
      int? savedAddressId;

      if (_currentAddress != null) {
        if (_isAddressFilled(_currentAddress!)) {
          if (_isAddressValid(_currentAddress!)) {
            final createdAddress = await _addressRepository.createAddress(_currentAddress!);
            savedAddressId = createdAddress.id;
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пожалуйста, заполните все поля адреса (город, улица, дом) или оставьте адрес пустым'),
                  backgroundColor: AppColors.error,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return null;
          }
        }
      }

      final motherWithAddress = _currentMother!.copyWith(
        addressId: savedAddressId,
      );

      final createdMother = await _motherRepository.createMother(motherWithAddress);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Мать успешно добавлена!'),
            backgroundColor: AppColors.brand_40,
          ),
        );
      }

      return createdMother;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void reset() {
    _currentMother = null;
    _currentAddress = null;
    _triedToSubmit = false;
    _isSaving = false;
    notifyListeners();
  }
}