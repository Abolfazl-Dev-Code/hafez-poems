abstract class BasePoem {
  String get id;
  String get title;
  String get text;
  String get audioUrl;
  bool get hasFullText;
}

class PoemJsonParser {
  PoemJsonParser._();

  static String id(Map<String, dynamic> json) =>
      (json['id'] ?? json['poemId'] ?? '').toString();

  static String title(Map<String, dynamic> json) =>
      (json['title'] ?? json['fullTitle'] ?? 'بدون عنوان').toString();

  static String text(Map<String, dynamic> json) {
    final plain = (json['plainText'] ?? '').toString().trim();
    if (plain.isNotEmpty) return plain;
    if (json['verses'] is List) {
      return (json['verses'] as List)
          .map((v) => (v['text'] ?? '').toString())
          .where((l) => l.trim().isNotEmpty)
          .join('\n');
    }
    return '';
  }

  static String audioUrl(Map<String, dynamic> json) {
    final recitations = json['recitations'];
    if (recitations is! List || recitations.isEmpty) return '';
    final valid = recitations.firstWhere(
      (r) => r['mp3Url'] != null && r['mp3Url'].toString().isNotEmpty,
      orElse: () => null,
    );
    return valid != null ? valid['mp3Url'].toString() : '';
  }
}
