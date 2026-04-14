import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
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
    _initControllers();
  }

  void _initControllers() {
    final parameters = widget.calculator.config['parameters'] ?? [];
    for (var param in parameters) {
      _controllers[param['name']] = TextEditingController();
    }
  }

  void _calculate() {
    final parameters = widget.calculator.config['parameters'] ?? [];
    final formulas = widget.calculator.config['formulas'] ?? [];

    Map<String, double> values = {};

    for (var param in parameters) {
      final controller = _controllers[param['name']];
      if (controller != null && controller.text.isNotEmpty) {
        values[param['name']] = double.tryParse(controller.text) ?? 0;
      }
    }

    Map<String, double> results = {};
    for (var formula in formulas) {
      String expression = formula['formula'];

      for (var entry in values.entries) {
        expression = expression.replaceAll(entry.key, entry.value.toString());
      }

      try {
        final result = _evaluateExpression(expression);
        results[formula['name']] = result;
      } catch (e) {
        results[formula['name']] = 0;
      }
    }

    setState(() {
      _results.clear();
      _results.addAll(results);
      _isCalculated = true;
    });
  }

  double _evaluateExpression(String expression) {
    try {
      final parser = Parser();
      final parsedExpression = parser.parse(expression);
      final contextModel = ContextModel();
      return parsedExpression.evaluate(EvaluationType.REAL, contextModel);
    } catch (e) {
      return 0;
    }
  }

  void _clearAll() {
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _results.clear();
      _isCalculated = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
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
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.calculator.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

          const Text(
            'Параметры',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...parameters.map((param) => _buildParameterField(param)),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF44E4BF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Рассчитать', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              if (_isCalculated)
                OutlinedButton(
                  onPressed: _clearAll,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Очистить'),
                ),
            ],
          ),

          if (_isCalculated && _results.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Результаты',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...formulas.map((formula) {
                    final result = _results[formula['name']];
                    final interpretation = _getInterpretation(formula['name'], result);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formula['label'] ?? formula['name'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                result != null
                                    ? '${result.toStringAsFixed(2)} ${formula['unit'] ?? ''}'
                                    : '—',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (interpretation != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              interpretation,
                              style: TextStyle(
                                color: _getColorForInterpretation(result),
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParameterField(Map<String, dynamic> param) {
    final name = param['name'];
    final label = param['label'];
    final unit = param['unit'];
    final type = param['type'] ?? 'number';
    final min = param['min'];
    final max = param['max'];

    if (type == 'radio' && param['options'] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: (param['options'] as List).map((option) {
              return ChoiceChip(
                label: Text(option['label']),
                selected: _controllers[name]?.text == option['value'],
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _controllers[name]?.text = option['value'];
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

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
        onChanged: (value) {
          if (min != null && value.isNotEmpty) {
            final numValue = double.tryParse(value);
            if (numValue != null && numValue < min) {
              _controllers[name]?.text = min.toString();
            }
          }
        },
      ),
    );
  }

  String? _getInterpretation(String resultName, double? value) {
    if (value == null) return null;

    final interpretations = widget.calculator.possibleResults;
    if (interpretations.isEmpty) return null;

    for (var interp in interpretations) {
      final min = interp['min'];
      final max = interp['max'];
      if (value >= min && value <= max) {
        return interp['text'];
      }
    }
    return null;
  }

  Color _getColorForInterpretation(double? value) {
    if (value == null) return Colors.grey;

    final interpretations = widget.calculator.possibleResults;
    for (var interp in interpretations) {
      final min = interp['min'];
      final max = interp['max'];
      if (value >= min && value <= max) {
        final color = interp['color'];
        switch (color) {
          case 'green': return Colors.green;
          case 'yellow': return Colors.orange;
          case 'orange': return Colors.orange;
          case 'red': return Colors.red;
          default: return Colors.grey;
        }
      }
    }
    return Colors.grey;
  }
}