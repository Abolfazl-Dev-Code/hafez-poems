class HighlightItem {
  final String poemId;
  final String category;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  final String highlightedLine;
  final int lineIndex;
  final int colorValue;

  HighlightItem({
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
    required this.highlightedLine,
    required this.lineIndex,
    required this.colorValue,
  });
}
