part of 'poem_cache_services.dart';

class PoemExcerpt {
  final String id;
  final String number;
  final String excerpt;
  final String category;

  const PoemExcerpt({
    required this.id,
    required this.number,
    required this.excerpt,
    required this.category,
  });
}

extension PoemExcerptExtraction<T> on BasePoemCacheService<T> {
  List<PoemExcerpt> randomExcerpts({int count = 5}) {
    final valid =
        _map.values
            .where((item) => hasFullTextOf(item) && textOf(item).trim().isNotEmpty)
            .toList()
          ..shuffle(Random());
    final result = <PoemExcerpt>[];
    for (final item in valid) {
      final excerpt = extractFirstFourBeyts(textOf(item));
      if (excerpt.isNotEmpty) {
        result.add(
          PoemExcerpt(
            id: idOf(item),
            number: numberOf(item),
            excerpt: excerpt,
            category: categoryLabel,
          ),
        );
        if (result.length >= count) break;
      }
    }
    return result;
  }

  String extractPoemNumber(String title) {
    final matches = RegExp(
      r'[0-9\u06F0-\u06F9\u0660-\u0669]+',
    ).allMatches(title).toList();
    if (matches.isEmpty) return '';
    return matches.last.group(0) ?? '';
  }

  String extractFirstFourBeyts(String text) {
    final lines = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll('/', '\n')
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) return '';
    final beyts = <String>[];
    for (int i = 0; i < lines.length && beyts.length < 4; i += 2) {
      final m2 = (i + 1 < lines.length) ? lines[i + 1] : '';
      beyts.add(m2.isNotEmpty ? '${lines[i]}\n$m2' : lines[i]);
    }
    return beyts.join('\n\n');
  }
}
