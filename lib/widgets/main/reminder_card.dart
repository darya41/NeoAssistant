import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String count;
  final String label;
  final bool isToday;

  const ReminderCard({super.key,
    required this.count,
    required this.label,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isToday ? Colors.white : const Color(0xFF7FEBD4);
    final countStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: isToday ? const Color(0xFF44E4BF) : Colors.black,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 160, minHeight: 70),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 0.2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF44E4BF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    count,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Text(count, style: countStyle),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isToday ? Colors.black87 : Colors.black54,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
