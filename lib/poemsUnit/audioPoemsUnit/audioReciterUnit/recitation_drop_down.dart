import 'package:flutter/material.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/audio_recitation_name_badge.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/recitation_picker_button.dart';

class RecitationDropdown extends StatelessWidget {
  final AudioPlayerController ctrl;
  final String poemId;
  final String category;
  final String poemTitle;
  final ThemeData theme;
  final ColorScheme cs;
  final void Function(RecitationInfo)? onRecitationChanged;

  const RecitationDropdown({
    super.key,
    required this.ctrl,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.theme,
    required this.cs,
    this.onRecitationChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (ctrl.isLoadingRecitations) {
      return SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'دریافت خوانندگان...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.recitations.length == 1) {
      return ArtistChip(
        artist: ctrl.recitations.first.audioArtist,
        cs: cs,
        theme: theme,
      );
    }

    return RecitationPickerButton(
      ctrl: ctrl,
      poemId: poemId,
      category: category,
      poemTitle: poemTitle,
      theme: theme,
      cs: cs,
      onRecitationChanged: onRecitationChanged,
    );
  }
}
