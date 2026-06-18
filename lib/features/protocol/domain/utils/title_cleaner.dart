class TitleCleaner {
  static const List<String> _excludedChapterTitles = [
    'ГЛАВА 1 ОБЩИЕ ПОЛОЖЕНИЯ',
    'ГЛАВА 1. ОБЩИЕ ПОЛОЖЕНИЯ',
    'ОБЩИЕ ПОЛОЖЕНИЯ',
  ];

  static String clean(String? title) {
    if (title == null || title.isEmpty) return 'Без названия';

    String cleaned = title;

    cleaned = cleaned.replaceAll(RegExp(r'^ГЛАВА\s+\d+\.?\s*', caseSensitive: false), '');

    cleaned = cleaned.replaceAll(RegExp(r'^ГЛАВА\s+\d+[-–]\d+\.?\s*', caseSensitive: false), '');

    cleaned = cleaned.replaceAll(RegExp(r'^\d+\.\s*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\d+\.\d+\.\s*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\d+\.\d+\.\d+\.\s*'), '');

    cleaned = cleaned.replaceAll(RegExp(r'^\d+\s+'), '');

    cleaned = cleaned.replaceAll(RegExp(r'^ГЛАВА\s+', caseSensitive: false), '');

    cleaned = cleaned.trim();

    return cleaned.isEmpty ? title : cleaned;
  }

  static bool isExcludedChapter(String? title, int level) {
    if (level != 1) return false;
    final lowerTitle = title?.toLowerCase() ?? '';
    for (final excluded in _excludedChapterTitles) {
      if (lowerTitle.contains(excluded.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}