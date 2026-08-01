import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/audio_tabs_sheet.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/verse_sync_controller.dart';

class RecitationPickerButton extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final String category;
  final String poemTitle;
  final VerseSyncController? verseSyncController;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged;

  const RecitationPickerButton({
    super.key,
    required this.ctrl,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    this.verseSyncController,
    required this.theme,
    required this.cs,
    this.onRecitationChanged,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AudioTabsSheet(
        recitations: ctrl.recitations,
        selected: ctrl.selectedRecitation,
        theme: theme,
        cs: cs,
        poemId: poemId,
        category: category,
        poemTitle: poemTitle,
        ctrl: ctrl,
        verseSyncController: verseSyncController,
        onSelect: (r) {
          ctrl.selectRecitation(poemId, r);
          onRecitationChanged?.call(r);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = ctrl.selectedRecitation;
    final isOffline = ctrl.isUsingOfflineAudio;

    final badgeColor = isOffline
        ? Colors.amber.shade700
        : Colors.green.shade700;

    final badgeBackground = badgeColor.withValues(alpha: .12);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () => _openPicker(context),
        borderRadius: AppRadius.mdRadius,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBackground,
                        borderRadius: AppRadius.xlRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: badgeColor),
                          const SizedBox(width: 4),
                          Text(
                            isOffline ? 'آفلاین' : 'آنلاین',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        selected?.audioArtist ?? 'انتخاب خواننده | دانلود',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: .85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: cs.primary.withValues(alpha: .7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
