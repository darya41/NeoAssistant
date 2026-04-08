class Reminder {
  final int id;
  final String title;
  final String? description;
  final DateTime date;
  bool isCompleted;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.isCompleted,
    required this.createdAt,
  });

  String get task => title;
  String get dateString => '${date.day} ${_getMonthName(date.month)} ${date.year}';

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['reminder_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['reminder_date']),
      isCompleted: json['is_completed'] == 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder_id': id,
      'title': title,
      'description': description,
      'reminder_date': date.toIso8601String().split('T')[0],
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  String _getMonthName(int month) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month - 1];
  }
}