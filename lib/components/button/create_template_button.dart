import 'package:flutter/material.dart';

class CreateTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateTemplateButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF44E4BF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.infinity, 56),
      ),
      child: Text(
        '+ Создать шаблон',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
