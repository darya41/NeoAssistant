import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String message;

  const EmptyContent({
    super.key,
    this.message = 'Нет данных для отображения',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}