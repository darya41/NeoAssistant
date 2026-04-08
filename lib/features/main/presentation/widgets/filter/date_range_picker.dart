import 'package:flutter/material.dart';

class DateRangePicker extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange) onRangeSelected;

  const DateRangePicker({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDateRange: selectedRange,
        );
        if (range != null) {
          onRangeSelected(range);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedRange != null
                  ? '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}'
                  : 'Выберите период',
              style: TextStyle(
                color: selectedRange != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}