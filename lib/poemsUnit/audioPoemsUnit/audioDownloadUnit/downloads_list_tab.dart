import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';
import 'package:hafez_poems/core/utils/audio_file_size_formatter.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
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
      onSyncUnavailable: () {
        verseSyncController?.clearSyncPoints();
      },
    );

    if (ctrl.hasPreparedAudio && ctrl.isUsingOfflineAudio) {
      AppSnackBarService.success(
        'نسخه آفلاین «${row.reciterDisplayName}» برای پخش انتخاب شد.',
        duration: const Duration(seconds: 3),
      );
    }

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

    if (confirmed != true) return;

    final manager = Get.find<AudioDownloadManager>();

    final wasCurrentOffline =
        ctrl.isUsingOfflineAudio && ctrl.selectedReciterKey == row.reciterKey;

    await manager.deleteDownload(poemId, category, row.reciterKey);

    if (wasCurrentOffline) {
      await ctrl.switchToOnlineVersion();
    }

    if (!context.mounted) return;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
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
            final isSelected =
                ctrl.isUsingOfflineAudio &&
                ctrl.selectedReciterKey == row.reciterKey;
            return InkWell(
              onTap: () => _play(context, row),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withValues(alpha: 0.08)
                      : cs.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green.withValues(alpha: 0.35)
                        : cs.primary.withValues(alpha: 0.15),
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : cs.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected
                            ? Icons.check_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                          if (isSelected) ...[
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'در حال استفاده',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          Text(
                            '${FileSizeFormatter.format(row.fileSizeBytes)} · برای پخش لمس کنید',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.primary.withValues(alpha: 0.7),
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
