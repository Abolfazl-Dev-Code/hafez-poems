import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_manager.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';
import 'download_row_tile.dart';
import 'downloads_empty_state.dart';

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
          shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
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
          return DownloadsEmptyState(theme: theme, cs: cs);
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
            return DownloadRowTile(
              row: row,
              isSelected: isSelected,
              theme: theme,
              cs: cs,
              onTap: () => _play(context, row),
              onDelete: () => _confirmDelete(context, row),
            );
          },
        );
      },
    );
  }
}
