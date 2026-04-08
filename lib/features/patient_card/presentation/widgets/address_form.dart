import 'package:flutter/material.dart';
import 'package:neo_friend/core/constants/app_strings.dart';
import '../../../../models/address.dart';
import 'form_fields/dropdown_with_text_field.dart';
import '../../../../shared/widgets/fields/text_input_field.dart';

class AddressForm extends StatefulWidget {
  final Function(Address?) onAddressChanged;
  final Address? initialAddress;

  const AddressForm({
    super.key,
    required this.onAddressChanged,
    this.initialAddress,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  String? _selectedSettlementType;
  String? _selectedAddressType;
  Address? _currentAddress;

  bool _cityIsEmpty = true;
  bool _streetIsEmpty = true;
  bool _houseNumberIsEmpty = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _loadInitialAddress(widget.initialAddress!);
    }
  }

  void _loadInitialAddress(Address address) {
    _cityController.text = address.city ?? '';
    _streetController.text = address.street ?? '';
    _houseNumberController.text = address.houseNumber ?? '';
    _buildingController.text = address.building ?? '';
    _apartmentController.text = address.apartment ?? '';
    _selectedSettlementType = address.settlementType;
    _selectedAddressType = address.addressType;

    _cityIsEmpty = _cityController.text.isEmpty;
    _streetIsEmpty = _streetController.text.isEmpty;
    _houseNumberIsEmpty = _houseNumberController.text.isEmpty;

    _currentAddress = address;
  }

  void _updateAddress() {
    final address = Address(
      id: _currentAddress?.id ?? 0,
      settlementType: _selectedSettlementType,
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      addressType: _selectedAddressType,
      street: _streetController.text.trim().isEmpty
          ? null
          : _streetController.text.trim(),
      houseNumber: _houseNumberController.text.trim().isEmpty
          ? null
          : _houseNumberController.text.trim(),
      building: _buildingController.text.trim().isEmpty
          ? null
          : _buildingController.text.trim(),
      apartment: _apartmentController.text.trim().isEmpty
          ? null
          : _apartmentController.text.trim(),
    );

    setState(() {
      _currentAddress = address;
    });

    widget.onAddressChanged(address);
  }

  bool get isAddressValid {
    return !_cityIsEmpty && !_streetIsEmpty && !_houseNumberIsEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Адрес проживания:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        DropdownWithTextField(
          label: 'Населённый пункт*:',
          selectedType: _selectedSettlementType,
          textController: _cityController,
          dropdownItems: const ['г.', 'д.', 'аг.'],
          dropdownHint: 'Тип',
          textFieldHint: 'Город/деревня*',
          onTypeChanged: (value) {
            setState(() => _selectedSettlementType = value);
            _updateAddress();
          },
          onTextChanged: (text) {
            setState(() => _cityIsEmpty = text.isEmpty);
            _updateAddress();
          },
          showError: _cityIsEmpty,
          errorText: _cityIsEmpty ? AppStrings.requiredField : null,
        ),
        const SizedBox(height: 12),

        DropdownWithTextField(
          label: 'Улица*:',
          selectedType: _selectedAddressType,
          textController: _streetController,
          dropdownItems: const ['ул.', 'пр-т', 'пер.', 'пл.'],
          dropdownHint: 'Тип',
          textFieldHint: 'Название улицы*',
          onTypeChanged: (value) {
            setState(() => _selectedAddressType = value);
            _updateAddress();
          },
          onTextChanged: (text) {
            setState(() => _streetIsEmpty = text.isEmpty);
            _updateAddress();
          },
          showError: _streetIsEmpty,
          errorText: _streetIsEmpty ? AppStrings.requiredField: null,
        ),
        const SizedBox(height: 12),

        TextInputField(
          hintText: 'Номер дома*',
          controller: _houseNumberController,
          onChanged: (text) {
            setState(() => _houseNumberIsEmpty = text.isEmpty);
            _updateAddress();
          },
          showError: _houseNumberIsEmpty,
          errorText: _houseNumberIsEmpty ? AppStrings.requiredField : null,
        ),
        const SizedBox(height: 12),

        TextInputField(
          hintText: 'Корпус',
          controller: _buildingController,
          onChanged: (_) => _updateAddress(),
        ),
        const SizedBox(height: 12),

        TextInputField(
          hintText: 'Квартира',
          controller: _apartmentController,
          onChanged: (_) => _updateAddress(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _buildingController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }
}