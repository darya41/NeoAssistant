import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/calculator.dart';

class FormulaCalculatorWidget extends StatefulWidget {
  final Calculator calculator;

  const FormulaCalculatorWidget({super.key, required this.calculator});

  @override
  State<FormulaCalculatorWidget> createState() => _FormulaCalculatorWidgetState();
}

class _FormulaCalculatorWidgetState extends State<FormulaCalculatorWidget> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, double?> _results = {};
  bool _isCalculated = false;

  @override
  void initState() {
    super.initState();
    for (var param in widget.calculator.config['parameters'] ?? []) {
      _controllers[param['name']] = TextEditingController();
    }
  }

  void _calculate() {
    final parameters = widget.calculator.config['parameters'] ?? [];
    final formulas = widget.calculator.config['formulas'] ?? [];

    Map<String, double> values = {};
    for (var param in parameters) {
      final text = _controllers[param['name']]?.text;
      if (text == null || text.isEmpty) {
        _showError('Заполните поле "${param['label']}"');
        return;
      }

      final value = double.tryParse(text.replaceAll(',', '.'));
      if (value == null) {
        _showError('Введите корректное число для "${param['label']}"');
        return;
      }
      values[param['name']] = value;
    }

    Map<String, double> results = {};
    for (var formula in formulas) {
      String expression = formula['formula'];

      for (var entry in values.entries) {
        expression = expression.replaceAll(entry.key, entry.value.toString());
      }

      final result = _evaluate(expression);
      results[formula['name']] = result;
    }

    setState(() {
      _results.clear();
      _results.addAll(results);
      _isCalculated = true;
    });
  }

  double _evaluate(String expression) {
    try {
      final result = GrammarParser()
          .parse(expression.replaceAll(',', '.'))
          .evaluate(EvaluationType.REAL, ContextModel());
      return double.parse(result.toStringAsFixed(2));
    } catch (e) {
      return 0;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _clearAll() {
    for (var c in _controllers.values) {
      c.clear();
    }
    setState(() {
      _results.clear();
      _isCalculated = false;
    });
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parameters = widget.calculator.config['parameters'] ?? [];
    final formulas = widget.calculator.config['formulas'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.calculator.description.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.neutral_5,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.calculator.description,
                  style: const TextStyle(fontSize: 14, color: AppColors.neutral_90)),
            ),

          const Text('Параметры',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...parameters.map((param) => _buildParameterField(param)).toList(),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand_40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Рассчитать', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              if (_isCalculated) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _clearAll,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: AppColors.brand_65,
                  ),
                  child: const Text(
                    'Очистить',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (_isCalculated && _results.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brand_5,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brand_5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Результаты',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...formulas.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(f['label'] ?? f['name'],
                            style: const TextStyle(fontSize: 16)),
                        Text(
                          '${(_results[f['name']] ?? 0).toStringAsFixed(2)} ${f['unit'] ?? ''}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParameterField(Map<String, dynamic> param) {
    final name = param['name'];
    final label = param['label'] ?? name;
    final unit = param['unit'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: _controllers[name],
        decoration: InputDecoration(
          labelText: label,
          hintText: unit != null ? 'Введите значение в $unit' : null,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}