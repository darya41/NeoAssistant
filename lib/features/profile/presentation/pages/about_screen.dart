import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Название приложения: Цифровой помощник врача-неонатолога',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Text('Версия: 1.03.02'),
            const SizedBox(height: 8.0),
            Text('Разработчик: Ермак Дарья Сергеевна'),
            const SizedBox(height: 8.0),
            Text('Дата выпуска: 01.06.2026'),
            const SizedBox(height: 8.0),
            Text('Описание: Это приложение создано для оптимизации работы врачей в отделении неонатологии.'),
          ],
        ),
      ),
    );
  }
}
