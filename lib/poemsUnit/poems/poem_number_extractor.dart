class PoemNumberExtractor {
  PoemNumberExtractor._();

  static const Map<String, String> _persianToEnglishDigits = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static int fromTitle(String title, {required String fallbackId}) {
    final matches = RegExp(
      r'[0-9\u06F0-\u06F9\u0660-\u0669]+',
    ).allMatches(title).toList();
    final raw = matches.isNotEmpty ? matches.last.group(0)! : fallbackId;
    final normalized = raw
        .split('')
        .map((c) => _persianToEnglishDigits[c] ?? c)
        .join();
    return int.tryParse(normalized) ?? 0;
  }
}
