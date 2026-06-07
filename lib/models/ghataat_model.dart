import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hive/hive.dart';

part 'ghataat_model.g.dart';

@HiveType(typeId: 12)
class GhataatModel extends HiveObject implements BasePoem {
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

  GhataatModel({
    required this.id,
    required this.title,
    this.text = '',
    this.audioUrl = '',
    this.hasFullText = false,
  });

  factory GhataatModel.fromJson(Map<String, dynamic> json) {
    final text = PoemJsonParser.text(json);
    return GhataatModel(
      id: PoemJsonParser.id(json),
      title: PoemJsonParser.title(json),
      text: text,
      hasFullText: text.isNotEmpty,
    );
  }
}
