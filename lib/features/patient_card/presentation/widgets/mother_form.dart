import 'package:flutter/material.dart';
import '../../../../models/address.dart';
import '../../../../models/mother.dart';
import 'address_form.dart';
import 'form_fields/date_field_widget.dart';
import 'form_fields/checkbox_group_widget.dart';
import 'form_fields/streptococcus_selector.dart';
import 'form_fields/text_input_field.dart';

class MotherFormWidget extends StatefulWidget {
  final Function(Mother) onMotherChanged;
  final Function(Address?) onAddressChanged;
  final Mother? initialMother;
  final bool showValidationErrors;
  final String? lastNameError;
  final String? firstNameError;
  final String? dateError;

  const MotherFormWidget({
    super.key,
    required this.onMotherChanged,
    this.initialMother,
    this.showValidationErrors = false,
    this.lastNameError,
    this.firstNameError,
    this.dateError,
    required this.onAddressChanged,
  });

  @override
  State<MotherFormWidget> createState() => _MotherFormWidgetState();
}

class _MotherFormWidgetState extends State<MotherFormWidget> {
  late final TextEditingController _lastNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _patronymicController;
  late final TextEditingController _dateController;
  late final TextEditingController _pregnanciesController;
  late final TextEditingController _deliveriesController;
  late final TextEditingController _medicalHistoryController;
  late final TextEditingController _medicationsController;

  DateTime? _selectedDate;
  bool _gestationalDiabetes = false;
  bool _preeclampsia = false;
  String? _groupBStreptococcus;
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.initialMother != null) {
      _loadInitialData(widget.initialMother!);
    }
  }

  void _initializeControllers() {
    _lastNameController = TextEditingController();
    _firstNameController = TextEditingController();
    _patronymicController = TextEditingController();
    _dateController = TextEditingController();
    _pregnanciesController = TextEditingController();
    _deliveriesController = TextEditingController();
    _medicalHistoryController = TextEditingController();
    _medicationsController = TextEditingController();

    _lastNameController.addListener(_updateMother);
    _firstNameController.addListener(_updateMother);
    _patronymicController.addListener(_updateMother);
    _pregnanciesController.addListener(_updateMother);
    _deliveriesController.addListener(_updateMother);
    _medicalHistoryController.addListener(_updateMother);
    _medicationsController.addListener(_updateMother);
  }

  void _loadInitialData(Mother mother) {
    _lastNameController.text = mother.lastName;
    _firstNameController.text = mother.firstName;
    _patronymicController.text = mother.patronymic ?? '';
    _selectedDate = mother.dateOfBirth;
    _dateController.text = '${mother.dateOfBirth.day}.${mother.dateOfBirth.month}.${mother.dateOfBirth.year}';
    _pregnanciesController.text = mother.numberOfPregnancies?.toString() ?? '';
    _deliveriesController.text = mother.numberOfDeliveries?.toString() ?? '';
    _medicalHistoryController.text = mother.medicalHistory ?? '';
    _medicationsController.text = mother.medicationsDuringPregnancy ?? '';
    _gestationalDiabetes = mother.gestationalDiabetes ?? false;
    _preeclampsia = mother.preeclampsia ?? false;
    _groupBStreptococcus = mother.groupBStreptococcusStatus;
  }

  Mother get _currentMother {
    return Mother(
      id: widget.initialMother?.id ?? 0,
      lastName: _lastNameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      patronymic: _patronymicController.text.trim().isEmpty
          ? null
          : _patronymicController.text.trim(),
      dateOfBirth: _selectedDate!,
      numberOfPregnancies: _pregnanciesController.text.isNotEmpty
          ? int.parse(_pregnanciesController.text)
          : null,
      numberOfDeliveries: _deliveriesController.text.isNotEmpty
          ? int.parse(_deliveriesController.text)
          : null,
      medicalHistory: _medicalHistoryController.text.trim().isEmpty
          ? null
          : _medicalHistoryController.text.trim(),
      medicationsDuringPregnancy: _medicationsController.text.trim().isEmpty
          ? null
          : _medicationsController.text.trim(),
      gestationalDiabetes: _gestationalDiabetes,
      preeclampsia: _preeclampsia,
      groupBStreptococcusStatus: _groupBStreptococcus,
    );
  }

  void _updateMother() {
    if (_selectedDate != null) {
      widget.onMotherChanged(_currentMother);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}.${picked.month}.${picked.year}';
      });
      _updateMother();
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _patronymicController.dispose();
    _dateController.dispose();
    _pregnanciesController.dispose();
    _deliveriesController.dispose();
    _medicalHistoryController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputField(
          controller: _lastNameController,
          hintText: 'Фамилия*',
          keyboardType: TextInputType.number,
          errorText: widget.lastNameError,
          showError: widget.showValidationErrors && widget.lastNameError != null,

        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText:'Имя*',
          controller: _firstNameController,
          onChanged: (_) {},
          errorText: widget.firstNameError,
          showError: widget.showValidationErrors && widget.firstNameError != null,
        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText: 'Отчество',
          controller: _patronymicController,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        DateFieldWidget(
          selectedDate: _selectedDate,
          onTap: _selectDate,
          errorText: widget.showValidationErrors ? widget.dateError : null,
          showError: widget.showValidationErrors && widget.dateError != null,
        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText:'Количество беременностей',
          controller: _pregnanciesController,
          keyboardType: TextInputType.number,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText: 'Количество родов',
          controller: _deliveriesController,
          keyboardType: TextInputType.number,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText: 'Анамнез',
          controller: _medicalHistoryController,
          maxLines: 3,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        TextInputField(
          hintText: 'Препараты во время беременности',
          controller: _medicationsController,
          maxLines: 2,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        CheckboxGroupWidget(
          gestationalDiabetes: _gestationalDiabetes,
          preeclampsia: _preeclampsia,
          onChanged: (gestational, preeclampsia) {
            setState(() {
              _gestationalDiabetes = gestational;
              _preeclampsia = preeclampsia;
            });
            _updateMother();
          },
        ),
        const SizedBox(height: 12),
        StreptococcusSelector(
          selectedValue: _groupBStreptococcus,
          onSelected: (value) {
            setState(() => _groupBStreptococcus = value);
            _updateMother();
          },
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        AddressForm(
          onAddressChanged: (address) {
            setState(() => _selectedAddress = address);
            widget.onAddressChanged(address);
            _updateMother();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}