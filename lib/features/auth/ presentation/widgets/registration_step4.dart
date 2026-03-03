import 'package:flutter/material.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';

class RegistrationStep4 extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(String) onPositionSelected;

  const RegistrationStep4({
    super.key,
    required this.onComplete,
    required this.onPositionSelected,
  });

  @override
  State<RegistrationStep4> createState() => _RegistrationStep4State();
}

class _RegistrationStep4State extends State<RegistrationStep4> {
  String? _selectedPosition;
  final TextEditingController _positionController = TextEditingController();
  final FocusNode _positionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _positionFocusNode.addListener(() {
      if (!_positionFocusNode.hasFocus && _positionController.text.isNotEmpty) {
        _selectCustomPosition();
      }
    });
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
        _selectedPosition = text;
      });
      widget.onPositionSelected(text);
    }
  }

  void _selectPredefinedPosition(String position) {
    setState(() {
      _selectedPosition = position;
      _positionController.text = position;
    });
    widget.onPositionSelected(position);
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
                              _selectedPosition = value;
                            });
                            widget.onPositionSelected(value);
                          } else {
                            setState(() {
                              _selectedPosition = null;
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


            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3.2,
              children: [
                _buildGridPositionButton('Врач-неонатолог'),
                _buildGridPositionButton('Реаниматолог'),
                _buildGridPositionButton('Неонатальный хирург'),
                _buildGridPositionButton('Главврач'),
              ],
            ),

            const Spacer(),

            ContinueButton(
              onPressed: widget.onComplete,
              isEnabled: _selectedPosition != null,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPositionButton(String position) {
    final isSelected = _selectedPosition == position;

    return GestureDetector(
      onTap: () => _selectPredefinedPosition(position),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF44E4BF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            position,
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