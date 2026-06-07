import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hive/hive.dart';

part 'robaeyat_model.g.dart';

@HiveType(typeId: 14)
class RobaeyatModel extends HiveObject implements BasePoem {
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
