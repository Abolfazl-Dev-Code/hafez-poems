class ReciterKey {
  ReciterKey._();

  static String from(String audioArtist) {
    return audioArtist
        .trim()
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ة', 'ه')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ی')
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')
        .replaceAll(RegExp(r'[!-/:-@[-`{-~،؛؟«»"()]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();
  }

  static int score(String candidate, String target) {
    final c = from(candidate);
    final t = from(target);

    // کاملاً برابر
    if (c == t) {
      return 1000;
    }

    final cWords = c.split(' ');
    final tWords = t.split(' ');

    int score = 0;

    for (final cw in cWords) {
      if (cw.isEmpty) continue;

      for (final tw in tWords) {
        if (tw.isEmpty) continue;

        if (cw == tw) {
          score += 100;
        }
      }
    }

    // یکی شامل دیگری باشد
    if (c.contains(t) || t.contains(c)) {
      score += 50;
    }

    return score;
  }

  static bool isSame(String a, String b) => score(a, b) > 0;
}
