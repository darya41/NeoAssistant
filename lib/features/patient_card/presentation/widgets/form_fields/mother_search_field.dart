import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/mother.dart';
import '../../../data/repositories/mother_repository.dart';
import '../../pages/add_mother_screen.dart';

class MotherSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(Mother) onMotherSelected;
  final String? errorText;

  static const _defaultBackgroundColor = AppColors.neutral_5;
  static const _borderColor = AppColors.neutral_25;
  static const _activeColor = AppColors.brand_40;

  const MotherSearchField({
    super.key,
    required this.controller,
    required this.onMotherSelected,
    this.errorText,
  });

  @override
  State<MotherSearchField> createState() => _MotherSearchFieldState();
}

class _MotherSearchFieldState extends State<MotherSearchField> {
  final MotherRepository _motherRepository = MotherRepository();
  List<Mother> _allMothers = [];
  List<Mother> _filteredMothers = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialMothers();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(MotherSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.text != widget.controller.text) {
      _onTextChanged();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Future<void> _loadInitialMothers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final mothers = await _motherRepository.getAllMothers();
      setState(() {
        _allMothers = mothers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTextChanged() {
    final query = widget.controller.text.trim().toLowerCase();
    _searchQuery = query;

    setState(() {
      if (query.isEmpty) {
        _filteredMothers = [];
        _showSuggestions = false;
      } else {
        _filteredMothers = _allMothers.where((mother) {
          return mother.fullName.toLowerCase().contains(query);
        }).toList();
        _showSuggestions = _filteredMothers.isNotEmpty;
      }
    });
  }

  void _selectMother(Mother mother) {
    setState(() {
      widget.controller.text = mother.fullName;
      _showSuggestions = false;
      _filteredMothers = [];
      _searchQuery = '';
    });
    widget.onMotherSelected(mother);
  }

  Future<void> _addNewMother() async {
    final result = await Navigator.push<Mother>(
      context,
      MaterialPageRoute(builder: (context) => const AddMotherScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _allMothers.add(result);
        widget.controller.text = result.fullName;
        _showSuggestions = false;
        _filteredMothers = [];
      });
      widget.onMotherSelected(result);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Мать "${result.fullName}" добавлена и выбрана'),
          duration: const Duration(seconds: 2),
          backgroundColor: MotherSearchField._activeColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: MotherSearchField._defaultBackgroundColor,
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red
                  : MotherSearchField._borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onChanged: (text) => _onTextChanged(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 20),
                    hintText: 'Введите ФИО матери для поиска',
                    border: InputBorder.none,
                    isDense: true,
                    errorText: null,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: MotherSearchField._borderColor,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: MotherSearchField._activeColor),
                onPressed: _addNewMother,
                tooltip: 'Добавить новую мать',
              ),
            ],
          ),
        ),

        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),

        if (_showSuggestions && _filteredMothers.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.neutral_0,
              border: Border.all(color: MotherSearchField._borderColor),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral_90,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredMothers.length,
              itemBuilder: (context, index) {
                final mother = _filteredMothers[index];
                return ListTile(
                  title: Text(
                    mother.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: mother.patronymic != null && mother.patronymic!.isNotEmpty
                      ? Text('Отчество: ${mother.patronymic}')
                      : null,
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _selectMother(mother),
                  hoverColor: MotherSearchField._activeColor,
                );
              },
            ),
          ),

        if (_searchQuery.isNotEmpty && !_showSuggestions && !_isLoading && _searchQuery.length > 2)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Мать с таким ФИО не найдена. Нажмите на кнопку "+" чтобы добавить новую мать.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}