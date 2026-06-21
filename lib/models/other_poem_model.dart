import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hive/hive.dart';

part 'other_poem_model.g.dart';

@HiveType(typeId: 16)
class OtherPoemModel extends HiveObject implements BasePoem {
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

  /// 'masnavi' یا 'saghiname' — برای تشخیص نوع شعر
  @HiveField(5)
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
