import 'package:hafez_poems/core/data/drift/tables.dart';

class DownloadProgressInfo {
  final int received;
  final int total;
  final DownloadStatus status;

  const DownloadProgressInfo({
    required this.received,
    required this.total,
    required this.status,
  });

  int get percentage => total > 0 ? ((received / total) * 100).round() : 0;
}
