import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class ArtistChip extends StatelessWidget {
  final String artist;
  final ColorScheme cs;
  final ThemeData theme;

  const ArtistChip({
    super.key,
    required this.artist,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.07),
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_rounded,
              size: 14,
              color: cs.primary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                artist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
