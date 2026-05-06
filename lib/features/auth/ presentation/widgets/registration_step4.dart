import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/icon_widgets.dart';
import '../../../../shared/widgets/buttons/continue_button.dart';
import '../../data/repositories/specialization_repository.dart';
import '../../domain/entities/specialization.dart';
import 'error_container.dart';
import 'form_field_container.dart';

class RegistrationStep4 extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(int) onPositionSelected;
  final int? selectedPositionId;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const RegistrationStep4({
    super.key,
    required this.onComplete,
    required this.onPositionSelected,
    this.selectedPositionId,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<RegistrationStep4> createState() => _RegistrationStep4State();
}

class _RegistrationStep4State extends State<RegistrationStep4> {
  final TextEditingController _positionController = TextEditingController();
  final FocusNode _positionFocusNode = FocusNode();

  List<Specialization> _specializations = [];
  bool _isLoadingLocal = false;
  String? _localErrorMessage;
  int? _selectedPositionId;

  final SpecializationRepository _repository = SpecializationRepository();

  @override
  void initState() {
    super.initState();
    _selectedPositionId = widget.selectedPositionId;
    _loadSpecializations();

    _positionFocusNode.addListener(() {
      if (!_positionFocusNode.hasFocus && _positionController.text.isNotEmpty) {
        _selectCustomPosition();
      }
    });
  }

  @override
  void didUpdateWidget(RegistrationStep4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPositionId != oldWidget.selectedPositionId) {
      _selectedPositionId = widget.selectedPositionId;
      if (widget.selectedPositionId != null) {
        final spec = _specializations.firstWhere(
              (s) => s.id == widget.selectedPositionId,
          orElse: () => Specialization(id: 0, name: ''),
        );
        if (spec.name.isNotEmpty) {
          _positionController.text = spec.name;
        }
      }
    }
  }

  Future<void> _loadSpecializations() async {
    setState(() {
      _isLoadingLocal = true;
      _localErrorMessage = null;
    });

    try {
      final specializations = await _repository.getSpecializations();
      setState(() {
        _specializations = specializations;
        _isLoadingLocal = false;
      });
    } catch (e) {
      setState(() {
        _localErrorMessage = 'Не удалось загрузить список должностей';
        _isLoadingLocal = false;
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
      setState(() => _selectedPositionId = 0);
      widget.onPositionSelected(0);
    }
  }

  void _selectPredefinedPosition(Specialization specialization) {
    setState(() {
      _selectedPositionId = specialization.id;
      _positionController.text = specialization.name;
    });
    widget.onPositionSelected(specialization.id);
  }

  String? get _firstError => widget.errorMessage ?? _localErrorMessage;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.isLoading || _isLoadingLocal;
    final isValid = _selectedPositionId != null && !isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Шаг 3/3',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ErrorContainer(
              errorMessage: _firstError,
              onRetry: () {
                widget.onRetry?.call();
                _loadSpecializations();
              },
            ),

            FormFieldContainer(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconWidgets.searchIcon(
                        onTap: () => FocusScope.of(context).requestFocus(_positionFocusNode),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _positionController,
                          focusNode: _positionFocusNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ваша должность',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (value) {
                            setState(() => _selectedPositionId = value.isNotEmpty ? 0 : null);
                            widget.onPositionSelected(value.isNotEmpty ? 0 : -1);
                          },
                          onSubmitted: (_) => _selectCustomPosition(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_specializations.isEmpty && _firstError == null)
              const Center(child: Text('Нет доступных должностей'))
            else
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3.2,
                  ),
                  itemCount: _specializations.length,
                  itemBuilder: (context, index) => _buildGridPositionButton(_specializations[index]),
                ),
              ),
            const SizedBox(height: 16),
            ContinueButton(
              onPressed: isValid ? widget.onComplete : null,
              isEnabled: isValid,
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
          color: isSelected ? AppColors.brand_40  : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              specialization.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}