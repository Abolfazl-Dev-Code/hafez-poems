import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hive/hive.dart';
part 'ghazal_model.g.dart';

@HiveType(typeId: 4)
class Ghazal extends HiveObject implements BasePoem {
  @override
  @HiveField(0)
  String id;

  @override
  @HiveField(1)
  String title;

  @override
  @HiveField(2)
  String text;

  @override
  @HiveField(3)
  String audioUrl;

  @override
  @HiveField(4)
  bool hasFullText;

  Ghazal({
    required this.id,
    required this.title,
    required this.text,
    required this.audioUrl,
    this.hasFullText = false,
  });

  factory Ghazal.fromListJson(Map<String, dynamic> json) => Ghazal(
    id: (json['id'] ?? json['poemId'] ?? '').toString(),
    title: (json['title'] ?? json['fullTitle'] ?? 'بدون عنوان').toString(),
    text: '',
    audioUrl: '',
  );

  factory Ghazal.fromDetailJson(Map<String, dynamic> json) {
    return Ghazal(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? json['fullTitle'] ?? 'بدون عنوان').toString(),
      text: _extractText(json),
      audioUrl: _extractAudioUrl(json),
      hasFullText: true,
    );
  }

  static String _extractText(Map<String, dynamic> json) {
    String text = (json['plainText'] ?? '').toString();
    if (text.trim().isEmpty && json['verses'] is List) {
      return (json['verses'] as List)
          .map((v) => (v['text'] ?? '').toString())
          .where((l) => l.trim().isNotEmpty)
          .join('\n');
    }
    return text;
  }

  static String _extractAudioUrl(Map<String, dynamic> json) {
    final recitations = json['recitations'];
    if (recitations is List && recitations.isNotEmpty) {
      final valid = recitations.firstWhere(
        (r) => r['mp3Url'] != null && r['mp3Url'].toString().isNotEmpty,
        orElse: () => null,
      );
      return valid != null ? valid['mp3Url'].toString() : '';
    }
    return '';
  }
}
