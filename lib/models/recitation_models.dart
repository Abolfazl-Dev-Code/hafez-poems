class RecitationInfo {
  final int id;
  final String audioArtist;
  final String mp3Url;
  final String xmlText;

  const RecitationInfo({
    required this.id,
    required this.audioArtist,
    required this.mp3Url,
    this.xmlText = '',
  });

  factory RecitationInfo.fromJson(Map<String, dynamic> json) => RecitationInfo(
    id: (json['id'] as num?)?.toInt() ?? 0,
    audioArtist: (json['audioArtist'] ?? json['artistName'] ?? 'نامشخص')
        .toString(),
    mp3Url: (json['mp3Url'] ?? json['audioUrl'] ?? '').toString(),
    xmlText: (json['xmlText'] ?? '').toString(),
  );

  @override
  String toString() => audioArtist;
}

class VerseSyncPoint {
  final int verseOrder;
  final int audioMilliseconds;

  const VerseSyncPoint({
    required this.verseOrder,
    required this.audioMilliseconds,
  });

  factory VerseSyncPoint.fromJson(Map<String, dynamic> json) => VerseSyncPoint(
    verseOrder: (json['verseOrder'] as num?)?.toInt() ?? 0,
    audioMilliseconds: (json['audioMiliseconds'] as num?)?.toInt() ?? 0,
  );

  Duration get startTime => Duration(milliseconds: audioMilliseconds);
}
