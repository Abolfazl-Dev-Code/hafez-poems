String normalize(String text) {
  return text
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\t', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}
