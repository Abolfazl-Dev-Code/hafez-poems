import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';
import 'package:hafez_poems/core/utils/audio_file_size_formatter.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_manager.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';

class DownloadsListTab extends StatelessWidget {
  final String poemId;
  final String category;
  final String poemTitle;
  final AudioPlayerController ctrl;
  final VerseSyncController? verseSyncController;
  final ThemeData theme;
  final ColorScheme cs;

  const DownloadsListTab({
    super.key,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.ctrl,
    required this.theme,
    required this.cs,
    this.verseSyncController,
  });

  Future<void> _play(BuildContext context, DownloadedAudioRow row) async {
    final resolver = Get.find<AudioSourceResolver>();

    await ctrl.loadWithSourceResolution(
      id: poemId,
      poemCategory: category,
      reciterKey: row.reciterKey,
      onlineUrl: row.sourceUrl,
      resolver: resolver,
      title: poemTitle,
      onSyncXmlResolved: (xml) {
        verseSyncController?.loadSyncPoints(xml);
      },
    );

    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DownloadedAudioRow row,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('حذف فایل دانلودشده'),
          content: Text(
            'فایل صوتی «${row.reciterDisplayName}» حذف شود؟ برای پخش دوباره باید مجدداً دانلود کنید.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('لغو'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final manager = Get.find<AudioDownloadManager>();
      await manager.deleteDownload(poemId, category, row.reciterKey);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فایل با موفقیت حذف شد')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<IAudioDownloadStorage>();

    return StreamBuilder<List<DownloadedAudioRow>>(
      stream: storage.watchDownloadsForPoem(poemId, category),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(
                  Icons.download_for_offline_outlined,
                  size: 36,
                  color: cs.onSurface.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 10),
                Text(
                  'هنوز فایلی برای این شعر دانلود نکرده‌اید',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'از تب «خوانندگان» می‌توانید صدا را دانلود کنید',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.35),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final row = items[index];
            return InkWell(
              onTap: () => _play(context, row),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 22,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.reciterDisplayName,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${row.fileName} · ${FileSizeFormatter.format(row.fileSizeBytes)}',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.45),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: cs.error,
                      ),
                      tooltip: 'حذف',
                      onPressed: () => _confirmDelete(context, row),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
