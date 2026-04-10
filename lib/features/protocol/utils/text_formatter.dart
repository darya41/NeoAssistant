// features/protocols/utils/text_formatter.dart
class TextFormatter {
  // Преобразовать ключ в заголовок
  static String formatTitle(String key) {
    String title = key.replaceAll('_', ' ');
    if (title.isEmpty) return '';
    return title[0].toUpperCase() + title.substring(1);
  }

  // Обрезать длинный текст
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}