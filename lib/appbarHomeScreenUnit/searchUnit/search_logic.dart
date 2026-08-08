final _digitAndLetterMap = <String, String>{
  '۰': '0', '٠': '0',
  '۱': '1', '١': '1',
  '۲': '2', '٢': '2',
  '۳': '3', '٣': '3',
  '۴': '4', '٤': '4',
  '۵': '5', '٥': '5',
  '۶': '6', '٦': '6',
  '۷': '7', '٧': '7',
  '۸': '8', '٨': '8',
  '۹': '9', '٩': '9',
  '\u064a': '\u06cc',
  '\u0643': '\u06a9',
};

final _digitRegex = RegExp(r'\d+');

String normalizeText(String text) {
  final buffer = StringBuffer();
  var pendingSpace = false;
  var hasContent = false;

  for (final rune in text.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '\u200c' || ch.trim().isEmpty) {
      if (hasContent) pendingSpace = true;
      continue;
    }
    if (pendingSpace) {
      buffer.write(' ');
      pendingSpace = false;
    }
    buffer.write(_digitAndLetterMap[ch] ?? ch);
    hasContent = true;
  }

  return buffer.toString().toLowerCase();
}

class IndexedPoem<T> {
  final T original;
  final String normalizedTitle;
  final String normalizedText;
  final String searchable;
  final List<String> titleWords;

  const IndexedPoem({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
    required this.searchable,
    required this.titleWords,
  });
}

class PoemSearchIndex<T> {
  PoemSearchIndex({
    required this.idOf,
    required this.titleOf,
    required this.textOf,
  });

  final String Function(T item) idOf;
  final String Function(T item) titleOf;
  final String Function(T item) textOf;
  final List<IndexedPoem<T>> _entries = [];

  void rebuild(Iterable<T> items) {
    _entries
      ..clear()
      ..addAll(items.map(_toIndexed));
  }

  void updateEntry(T item) {
    final idx = _entries.indexWhere((e) => idOf(e.original) == idOf(item));
    final entry = _toIndexed(item);
    if (idx != -1) {
      _entries[idx] = entry;
    } else {
      _entries.add(entry);
    }
  }

  IndexedPoem<T> _toIndexed(T item) {
    final normalizedTitle = normalizeText(titleOf(item));
    final normalizedText = normalizeText(textOf(item));
    return IndexedPoem(
      original: item,
      normalizedTitle: normalizedTitle,
      normalizedText: normalizedText,
      searchable: '$normalizedTitle $normalizedText',
      titleWords: normalizedTitle.split(' '),
    );
  }

  List<MapEntry<T, int>> searchWithScore(String normalizedQuery) {
    if (normalizedQuery.trim().isEmpty) return [];

    final tokens = normalizedQuery
        .split(' ')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (tokens.isEmpty) return [];

    final result = <MapEntry<T, int>>[];

    for (final e in _entries) {
      if (!tokens.every((token) => e.searchable.contains(token))) continue;

      final score = _scoreEntry(e, normalizedQuery, tokens);
      result.add(MapEntry(e.original, score));
    }

    return result;
  }

  List<T> search(String normalizedQuery) =>
      searchWithScore(normalizedQuery).map((e) => e.key).toList();

  int _scoreEntry(
    IndexedPoem<T> e,
    String normalizedQuery,
    List<String> tokens,
  ) {
    final title = e.normalizedTitle;
    final text = e.normalizedText;

    if (title == normalizedQuery) return 100;
    if (title.startsWith(normalizedQuery)) return 95;
    // اگر کوئری شامل عدد بود، تطابق دقیق‌تر عددی را اولویت بده
    final numberMatch = _digitRegex.firstMatch(normalizedQuery);
    if (numberMatch != null) {
      final queryNumber = numberMatch.group(0)!;

      final titleNumberMatch = _digitRegex.firstMatch(title);

      if (titleNumberMatch != null) {
        final titleNumber = titleNumberMatch.group(0)!;

        if (titleNumber == queryNumber) {
          return 99; // غزل 1
        }

        if (titleNumber.startsWith(queryNumber)) {
          // غزل 11 بهتر از غزل 111
          return 98 - (titleNumber.length - queryNumber.length);
        }
      }
    }
    if (title.contains(normalizedQuery)) return 90;

    if (tokens.length > 1 && text.contains(normalizedQuery)) {
      return 85;
    }

    if (e.titleWords.any((w) => w.startsWith(normalizedQuery))) return 60;

    int matchedTokens = 0;
    for (final token in tokens) {
      if (text.contains(token)) matchedTokens++;
    }
    final ratio = matchedTokens / tokens.length;

    return 10 + (ratio * 45).round();
  }
}
