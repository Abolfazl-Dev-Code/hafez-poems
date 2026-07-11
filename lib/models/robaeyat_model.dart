import 'package:hafez_poems/models/base_poem_model.dart';

class RobaeyatModel implements BasePoem {
  @override
  final String id;
  @override
  final String title;
  @override
  String text;
  @override
  String audioUrl;
  @override
  bool hasFullText;

  RobaeyatModel({
    required this.id,
    required this.title,
    this.text = '',
    this.audioUrl = '',
    this.hasFullText = false,
  });

  factory RobaeyatModel.fromJson(Map<String, dynamic> json) {
    final text = PoemJsonParser.text(json);
    return RobaeyatModel(
      id: PoemJsonParser.id(json),
      title: PoemJsonParser.title(json),
      text: text,
      hasFullText: text.isNotEmpty,
    );
  }
}
