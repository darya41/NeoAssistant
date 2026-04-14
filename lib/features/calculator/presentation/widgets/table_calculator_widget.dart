import 'package:flutter/material.dart';
import '../../domain/entities/calculator.dart';

class TableCalculatorWidget extends StatefulWidget {
  final Calculator calculator;

  const TableCalculatorWidget({super.key, required this.calculator});

  @override
  State<TableCalculatorWidget> createState() => _TableCalculatorWidgetState();
}

class _TableCalculatorWidgetState extends State<TableCalculatorWidget> {
  final Map<String, int> _selectedScores = {};
  int? _totalScore;

  @override
  Widget build(BuildContext context) {
    final criteria = widget.calculator.config['criteria'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: criteria.length,
              itemBuilder: (context, index) {
                final criterion = criteria[index];
                final label = criterion['label'];
                final options = criterion['options'] as List;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...options.map((option) {
                          final score = option['score'];
                          final text = option['text'];
                          return RadioListTile<int>(
                            title: Text(text),
                            value: score,
                            groupValue: _selectedScores[label],
                            onChanged: (value) {
                              setState(() {
                                _selectedScores[label] = value!;
                                _calculateTotal();
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildResult(),
        ],
      ),
    );
  }

  void _calculateTotal() {
    _totalScore = _selectedScores.values.reduce((a, b) => a + b);
  }

  Widget _buildResult() {
    if (_totalScore == null) {
      return Container();
    }

    String? resultText;
    Color? resultColor;

    for (var interpretation in widget.calculator.possibleResults) {
      final min = interpretation['min'];
      final max = interpretation['max'];
      if (_totalScore! >= min && _totalScore! <= max) {
        resultText = interpretation['text'];
        break;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: resultColor ?? Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            'Результат: $_totalScore баллов',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (resultText != null)
            Text(
              resultText,
              style: TextStyle(
                fontSize: 18,
                color: resultColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }


}