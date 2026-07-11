import 'package:hafez_poems/models/base_poem_model.dart';

class OtherPoemModel implements BasePoem {
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
  final String kind;

  OtherPoemModel({
    required this.id,
    required this.title,
    required this.kind,
    this.text = '',
    this.audioUrl = '',
    this.hasFullText = false,
  });

  factory OtherPoemModel.fromJson(Map<String, dynamic> json) => OtherPoemModel(
    id: json['id'].toString(),
    title: json['title'].toString(),
    kind: json['kind'].toString(),
    text: json['text'].toString(),
    hasFullText: true,
  );
}
