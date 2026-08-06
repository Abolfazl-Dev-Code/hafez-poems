import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_download_control.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/set_default_reciter.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';

class ReciterListTile extends StatelessWidget {
  final RecitationInfo recitation;
  final bool isSelected;
  final ThemeData theme;
  final ColorScheme cs;
  final String poemId;
  final String category;
  final String poemTitle;
  final AudioPlayerController ctrl;
  final void Function(RecitationInfo) onSelect;

  const ReciterListTile({
    super.key,
    required this.recitation,
    required this.isSelected,
    required this.theme,
    required this.cs,
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.ctrl,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final r = recitation;
    final initial = r.audioArtist.isNotEmpty
        ? r.audioArtist.characters.first
        : '؟';
    final reciterKey = ReciterKey.from(r.audioArtist);

    return InkWell(
      onTap: () {
        onSelect(r);
        Navigator.pop(context);
      },
      borderRadius: AppRadius.mdRadius,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.15)
                    : cs.onSurface.withValues(alpha: 0.07),
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                r.audioArtist,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 14),
            ReciterDownloadControl(
              poemId: poemId,
              category: category,
              poemTitle: poemTitle,
              reciterKey: reciterKey,
              reciterDisplayName: r.audioArtist,
              sourceUrl: r.mp3Url,
              sourceRecitationId: r.id,
              syncXml: r.xmlText,
              cs: cs,
            ),
            DefaultReciterStar(
              category: category,
              reciterKey: reciterKey,
              reciterDisplayName: r.audioArtist,
              cs: cs,
              onSetDefault: () {
                ctrl.selectRecitation(poemId, r);
                onSelect(r);
              },
            ),
          ],
        ),
      ),
    );
  }
}
