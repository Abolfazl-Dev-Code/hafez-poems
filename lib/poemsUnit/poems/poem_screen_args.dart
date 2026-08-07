class PoemScreenArgs {
  final String id;
  final String category;
  final String title;
  final String text;
  final String audioUrl;
  final Future<String> Function(String id) fetchText;
  final Future<String> Function(String id)? fetchAudioUrl;
  final int? highlightLineIndex;

  const PoemScreenArgs({
    required this.id,
    required this.category,
    required this.title,
    required this.text,
    required this.fetchText,
    this.audioUrl = '',
    this.fetchAudioUrl,
    this.highlightLineIndex,
  });

  bool get hasAudio => audioUrl.isNotEmpty || fetchAudioUrl != null;
}
