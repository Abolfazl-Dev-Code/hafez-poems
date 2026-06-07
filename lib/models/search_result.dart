enum SearchResultType { ghazal, ghataat, qasaid, robaeyat, montasab }

class SearchResult {
  final String id;
  final String title;
  final String text;
  final String audioUrl;
  final SearchResultType type;

  const SearchResult({
    required this.id,
    required this.title,
    required this.text,
    required this.audioUrl,
    required this.type,
  });

  String get typeLabel => switch (type) {
    SearchResultType.ghazal => 'غزل',
    SearchResultType.ghataat => 'قطعه',
    SearchResultType.qasaid => 'قصیده',
    SearchResultType.robaeyat => 'رباعی',
    SearchResultType.montasab => 'منتسب',
  };
}
