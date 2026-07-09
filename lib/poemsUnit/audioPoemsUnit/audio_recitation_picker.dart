import 'package:flutter/material.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_recitation_picker_sheet.dart';

class RecitationPickerButton extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged;

  const RecitationPickerButton({
    super.key,
    required this.ctrl,
    required this.poemId,
    required this.theme,
    required this.cs,
    this.onRecitationChanged,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecitationPickerSheet(
        recitations: ctrl.recitations,
        selected: ctrl.selectedRecitation,
        theme: theme,
        cs: cs,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () => _openPicker(context),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.mic_rounded,
                size: 14,
                color: cs.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  selected?.audioArtist ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: cs.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
