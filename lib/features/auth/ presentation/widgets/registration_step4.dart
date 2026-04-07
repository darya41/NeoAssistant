import 'package:flutter/material.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../data/repositories/specialization_repository.dart';
import '../../../../models/specialization.dart';

class RegistrationStep4 extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(int) onPositionSelected;

  const RegistrationStep4({
    super.key,
    required this.onComplete,
    required this.onPositionSelected,
  });

  @override
  State<RegistrationStep4> createState() => _RegistrationStep4State();
}

class _RegistrationStep4State extends State<RegistrationStep4> {
  int? _selectedPositionId;
  String? _selectedPositionName;

  final TextEditingController _positionController = TextEditingController();
  final FocusNode _positionFocusNode = FocusNode();

  List<Specialization> _specializations = [];
  bool _isLoading = true;
  String? _errorMessage;

  final SpecializationRepository _repository = SpecializationRepository();

  @override
  void initState() {
    super.initState();
    _positionFocusNode.addListener(() {
      if (!_positionFocusNode.hasFocus && _positionController.text.isNotEmpty) {
        _selectCustomPosition();
      }
    });
    _loadSpecializations();
  }

  Future<void> _loadSpecializations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final specializations = await _repository.getSpecializations();
      setState(() {
        _specializations = specializations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Не удалось загрузить список должностей';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _positionFocusNode.dispose();
    super.dispose();
  }

  void _selectCustomPosition() {
    final text = _positionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _selectedPositionId = 0;
        _selectedPositionName = text;
      });
      widget.onPositionSelected(0);
    }
  }

  void _selectPredefinedPosition(Specialization specialization) {
    setState(() {
      _selectedPositionId = specialization.id;
      _selectedPositionName = specialization.name;
      _positionController.text = specialization.name;
    });
    widget.onPositionSelected(specialization.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            const Text(
              'Шаг 3/3',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 70),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconWidgets.searchIcon(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_positionFocusNode);
                      },
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller: _positionController,
                        focusNode: _positionFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ваша должность',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _selectedPositionId = 0;
                              _selectedPositionName = value;
                            });
                            widget.onPositionSelected(0);
                          } else {
                            setState(() {
                              _selectedPositionId = null;
                              _selectedPositionName = null;
                            });
                          }
                        },
                        onSubmitted: (value) {
                          _selectCustomPosition();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadSpecializations,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
            else if (_specializations.isEmpty)
                const Center(
                  child: Text('Нет доступных должностей'),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3.2,
                  ),
                  itemCount: _specializations.length,
                  itemBuilder: (context, index) {
                    final spec = _specializations[index];
                    return _buildGridPositionButton(spec);
                  },
                ),

            const Spacer(),

            ContinueButton(
              onPressed: _selectedPositionId != null ? widget.onComplete : () {},
              isEnabled: _selectedPositionId != null,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPositionButton(Specialization specialization) {
    final isSelected = _selectedPositionId == specialization.id;

    return GestureDetector(
      onTap: () => _selectPredefinedPosition(specialization),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF44E4BF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            specialization.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}