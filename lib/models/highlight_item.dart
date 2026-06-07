import 'package:hive/hive.dart';

part 'highlight_item.g.dart';

@HiveType(typeId: 2)
class HighlightItem extends HiveObject {
  @HiveField(0)
  final String ghazalId;

  @HiveField(1)
  final String ghazalTitle;

  @HiveField(2)
  final String ghazalText;

  @HiveField(3)
  final String audioUrl;

  @HiveField(4)
  final String highlightedLine;

  @HiveField(5)
  final int lineIndex;

  @HiveField(6)
  final int colorValue;

  HighlightItem({
    required this.ghazalId,
    required this.ghazalTitle,
    required this.ghazalText,
    required this.audioUrl,
    required this.highlightedLine,
    required this.lineIndex,
    required this.colorValue,
  });
}
