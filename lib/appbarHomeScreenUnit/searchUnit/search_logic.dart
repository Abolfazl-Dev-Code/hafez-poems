class IndexedPoem<T> {
  final T original;
  final String normalizedTitle;
  final String normalizedText;

  const IndexedPoem({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
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

  IndexedPoem<T> _toIndexed(T item) => IndexedPoem(
    original: item,
    normalizedTitle: _normalize(titleOf(item)),
    normalizedText: _normalize(textOf(item)),
  );

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
      final searchable = '${e.normalizedTitle} ${e.normalizedText}';
      if (!tokens.every((token) => searchable.contains(token))) continue;

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
    final numberMatch = RegExp(r'\d+').firstMatch(normalizedQuery);
    if (numberMatch != null) {
      final queryNumber = numberMatch.group(0)!;

      final titleNumberMatch = RegExp(r'\d+').firstMatch(title);

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

    final titleWords = title.split(' ');
    if (titleWords.any((w) => w.startsWith(normalizedQuery))) return 60;

    int matchedTokens = 0;
    for (final token in tokens) {
      if (text.contains(token)) matchedTokens++;
    }
    final ratio = matchedTokens / tokens.length;

    return 10 + (ratio * 45).round();
  }

  String _normalize(String text) => text
      .replaceAll('۰', '0')
      .replaceAll('٠', '0')
      .replaceAll('۱', '1')
      .replaceAll('١', '1')
      .replaceAll('۲', '2')
      .replaceAll('٢', '2')
      .replaceAll('۳', '3')
      .replaceAll('٣', '3')
      .replaceAll('۴', '4')
      .replaceAll('٤', '4')
      .replaceAll('۵', '5')
      .replaceAll('٥', '5')
      .replaceAll('۶', '6')
      .replaceAll('٦', '6')
      .replaceAll('۷', '7')
      .replaceAll('٧', '7')
      .replaceAll('۸', '8')
      .replaceAll('٨', '8')
      .replaceAll('۹', '9')
      .replaceAll('٩', '9')
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}
