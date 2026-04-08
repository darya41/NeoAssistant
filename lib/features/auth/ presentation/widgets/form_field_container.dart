import 'package:flutter/material.dart';

class FormFieldContainer extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final double radius;

  const FormFieldContainer({
    super.key,
    required this.children,
    this.color,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}