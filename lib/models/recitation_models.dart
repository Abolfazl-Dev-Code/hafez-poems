// lib/models/recitation_models.dart

/// یک خواننده از API گنجور
class RecitationInfo {
  final int id;
  final String audioArtist;
  final String mp3Url;
  final String xmlText; // ← اضافه

  const RecitationInfo({
    required this.id,
    required this.audioArtist,
    required this.mp3Url,
    this.xmlText = '', // ← اضافه
  });

  factory RecitationInfo.fromJson(Map<String, dynamic> json) => RecitationInfo(
    id: (json['id'] as num?)?.toInt() ?? 0,
    audioArtist: (json['audioArtist'] ?? json['artistName'] ?? 'نامشخص')
        .toString(),
    mp3Url: (json['mp3Url'] ?? json['audioUrl'] ?? '').toString(),
    xmlText: (json['xmlText'] ?? '').toString(), // ← اضافه
  );

  @override
  String toString() => audioArtist;
}

/// زمان‌بندی یک مصراع — از syncArray گنجور
class VerseSyncPoint {
  /// شماره ترتیب مصراع (verseOrder در API)
  final int verseOrder;

  /// زمان شروع این مصراع در فایل صوتی (میلی‌ثانیه)
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
