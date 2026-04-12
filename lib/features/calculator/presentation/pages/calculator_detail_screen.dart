import 'package:flutter/material.dart';
import '../../domain/entities/calculator.dart';
import '../widgets/calendar_calculator_widget.dart';
import '../widgets/formula_calculator_widget.dart';
import '../widgets/table_calculator_widget.dart';

class CalculatorDetailScreen extends StatelessWidget {
  final Calculator calculator;

  const CalculatorDetailScreen({
    super.key,
    required this.calculator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(calculator.name),
        backgroundColor: const Color(0xFF44E4BF),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (calculator.type) {
      case 'formula':
        return FormulaCalculatorWidget(calculator: calculator);
      case 'table':
        return TableCalculatorWidget(calculator: calculator);
     case 'calendar':
       return CalendarCalculatorWidget(calculator: calculator);
     default:
        return const Center(child: Text('Тип калькулятора не поддерживается'));
    }
  }
}