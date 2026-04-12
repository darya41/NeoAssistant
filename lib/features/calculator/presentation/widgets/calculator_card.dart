import 'package:flutter/material.dart';
import '../../domain/entities/calculator.dart';

class CalculatorCard extends StatelessWidget {
  final Calculator calculator;
  final VoidCallback onTap;

  const CalculatorCard({
    super.key,
    required this.calculator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      calculator.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                calculator.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _buildTypeChip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (calculator.type) {
      case 'formula':
        icon = Icons.calculate;
        color = Colors.blue;
        break;
      case 'table':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'logical':
        icon = Icons.psychology;
        color = Colors.purple;
        break;
      case 'calendar':
        icon = Icons.calendar_today;
        color = Colors.orange;
        break;
      default:
        icon = Icons.calculate;
        color = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildTypeChip() {
    String typeText;
    Color color;

    switch (calculator.type) {
      case 'formula':
        typeText = 'Формула';
        color = Colors.blue;
        break;
      case 'table':
        typeText = 'Таблица';
        color = Colors.green;
        break;
      case 'logical':
        typeText = 'Логический';
        color = Colors.purple;
        break;
      case 'calendar':
        typeText = 'Календарь';
        color = Colors.orange;
        break;
      default:
        typeText = 'Калькулятор';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}