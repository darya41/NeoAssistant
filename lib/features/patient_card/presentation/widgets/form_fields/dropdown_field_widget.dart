import 'package:flutter/material.dart';

class DropdownFieldWidget<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;
  final double width;

  static const _defaultBackgroundColor = Color(0xFFF3F3F3);
  static const _borderColor = Color(0xFFC6C6C6);

  const DropdownFieldWidget({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _defaultBackgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabel(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}