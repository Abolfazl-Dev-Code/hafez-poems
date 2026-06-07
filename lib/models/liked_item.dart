import 'package:hive/hive.dart';

part 'liked_item.g.dart';

@HiveType(typeId: 0)
class LikedItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final String audioUrl;

  LikedItem({
    required this.id,
    required this.title,
    required this.text,
    required this.audioUrl,
  });
}
