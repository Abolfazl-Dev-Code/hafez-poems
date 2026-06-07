import 'package:hive/hive.dart';

part 'saved_item.g.dart';

@HiveType(typeId: 1)
class SavedItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final String audioUrl;

  SavedItem({
    required this.id,
    required this.title,
    required this.text,
    required this.audioUrl,
  });
}
