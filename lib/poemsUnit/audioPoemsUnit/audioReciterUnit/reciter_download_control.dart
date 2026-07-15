import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';
import 'package:hafez_poems/core/data/drift/tables.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_manager.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/download_progress_info.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_category_labels.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_number_extractor.dart';
import 'package:hafez_poems/poemsUnit/poems/poet_info.dart';

class ReciterDownloadControl extends StatelessWidget {
  final String poemId;
  final String category;
  final String poemTitle;
  final String reciterKey;
  final String reciterDisplayName;
  final String sourceUrl;
  final int? sourceRecitationId;
  final String? syncXml;
  final ColorScheme cs;

  const ReciterDownloadControl({
    super.key,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.reciterKey,
    required this.reciterDisplayName,
    required this.sourceUrl,
    this.sourceRecitationId,
    this.syncXml,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<IAudioDownloadStorage>();
    final manager = Get.find<AudioDownloadManager>();

    return StreamBuilder<DownloadedAudioRow?>(
      stream: storage.watchStatus(poemId, category, reciterKey),
      builder: (context, snapshot) {
        final persistedStatus =
            snapshot.data?.status ?? DownloadStatus.notDownloaded;

        return AnimatedBuilder(
          animation: manager,
          builder: (context, _) {
            final isActive = manager.isDownloading(
              poemId,
              category,
              reciterKey,
            );
            final progress = manager.progressFor(poemId, category, reciterKey);
            final effectiveStatus = isActive
                ? DownloadStatus.downloading
                : persistedStatus;
            return _buildForStatus(context, effectiveStatus, progress, manager);
          },
        );
      },
    );
  }

  Widget _buildForStatus(
    BuildContext context,
    DownloadStatus status,
    DownloadProgressInfo? progress,
    AudioDownloadManager manager,
  ) {
    switch (status) {
      case DownloadStatus.notDownloaded:
        return IconButton(
          icon: Icon(Icons.download_rounded, size: 20, color: cs.primary),
          tooltip: 'دانلود',
          onPressed: () => _start(manager),
        );
      case DownloadStatus.downloading:
        final pct = progress?.percentage ?? 0;
        return InkWell(
          onTap: () => manager.cancelDownload(poemId, category, reciterKey),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$pct%',
                  style: TextStyle(fontSize: 11, color: cs.primary),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: pct > 0 ? pct / 100 : null,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      case DownloadStatus.downloaded:
        return Icon(
          Icons.check_circle_rounded,
          size: 20,
          color: Colors.green.shade600,
        );
      case DownloadStatus.error:
        return TextButton.icon(
          onPressed: () => _start(manager, isRetry: true),
          icon: Icon(Icons.refresh_rounded, size: 15, color: cs.error),
          label: Text(
            'تلاش مجدد',
            style: TextStyle(fontSize: 11, color: cs.error),
          ),
        );
    }
  }

  Future<void> _start(AudioDownloadManager manager, {bool isRetry = false}) {
    final poemNumber = PoemNumberExtractor.fromTitle(
      poemTitle,
      fallbackId: poemId,
    );
    final categoryLabel = PoemCategoryLabels.labelFor(category);
    final action = isRetry ? manager.retryDownload : manager.startDownload;
    return action(
      poemId: poemId,
      poemCategory: category,
      reciterKey: reciterKey,
      reciterDisplayName: reciterDisplayName,
      sourceUrl: sourceUrl,
      fileNameCategory: categoryLabel,
      fileNamePoemNumber: poemNumber,
      poetName: PoetInfo.defaultPoetName,
      sourceRecitationId: sourceRecitationId,
      syncXml: syncXml,
    );
  }
}
