import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_player_controller.dart';

class SpeedButtons extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ColorScheme cs;
  final ThemeData theme;

  const SpeedButtons({
    super.key,
    required this.ctrl,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      enabled: ctrl.isAudioLoaded,
      onSelected: (speed) => ctrl.setPlaybackSpeed(speed),
      offset: const Offset(-20, -180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: cs.surface,
      tooltip: 'سرعت پخش',
      itemBuilder: (_) => AudioPlayerController.supportedSpeeds.map((speed) {
        final isSelected = ctrl.playbackSpeed == speed;
        return PopupMenuItem<double>(
          value: speed,
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_rounded : null,
                size: 18,
                color: cs.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${speed}x',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        decoration: BoxDecoration(
          color: ctrl.isAudioLoaded
              ? cs.surfaceContainerHighest.withValues(alpha: 0.6)
              : cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Text(
          '${ctrl.playbackSpeed}x',
          style: theme.textTheme.labelMedium?.copyWith(
            color: ctrl.isAudioLoaded
                ? cs.onSurface.withValues(alpha: 0.75)
                : cs.onSurface.withValues(alpha: 0.35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
