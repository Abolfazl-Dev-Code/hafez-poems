import 'package:hive/hive.dart';

part 'fal_model.g.dart';

@HiveType(typeId: 13)
class FalModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String plainText;

  @HiveField(3)
  final String audioUrl;

  @HiveField(4)
  final String poemUrl;

  FalModel({
    required this.id,
    required this.title,
    required this.plainText,
    this.audioUrl = '',
    this.poemUrl = '',
  });

  factory FalModel.fromJson(Map<String, dynamic> json) {
    String text = (json['plainText'] ?? '').toString().trim();
    if (text.isEmpty && json['verses'] is List) {
      text = (json['verses'] as List)
          .map((v) => (v['text'] ?? '').toString())
          .where((l) => l.trim().isNotEmpty)
          .join('\n');
    }
    String audioUrl = '';
    if (json['recitations'] is List) {
      final recitations = json['recitations'] as List;
      if (recitations.isNotEmpty) {
        final first = recitations.first as Map<String, dynamic>;
        audioUrl = (first['mp3Url'] ?? '').toString();
      }
    }

    final poemUrl = (json['urlSlug'] != null)
        ? 'https://ganjoor.net${json['urlSlug']}'
        : '';

    return FalModel(
      id: (json['id'] ?? 0) is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: (json['title'] ?? json['fullTitle'] ?? 'بدون عنوان').toString(),
      plainText: text,
      audioUrl: audioUrl,
      poemUrl: poemUrl,
    );
  }

  List<String> get lines => plainText
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool get hasAudio => audioUrl.isNotEmpty;
}
