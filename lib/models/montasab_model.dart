import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hive/hive.dart';

part 'montasab_model.g.dart';

@HiveType(typeId: 15)
class MontasabModel extends HiveObject implements BasePoem {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  String text;

  @override
  @HiveField(3)
  String audioUrl;

  @override
  @HiveField(4)
  bool hasFullText;

  MontasabModel({
    required this.id,
    required this.title,
    this.text = '',
    this.audioUrl = '',
    this.hasFullText = false,
  });

  factory MontasabModel.fromJson(Map<String, dynamic> json) {
    final text = PoemJsonParser.text(json);
    return MontasabModel(
      id: PoemJsonParser.id(json),
      title: PoemJsonParser.title(json),
      text: text,
      hasFullText: text.isNotEmpty,
    );
  }
}
