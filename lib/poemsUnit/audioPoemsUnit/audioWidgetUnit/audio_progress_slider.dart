import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';

class AudioProgressSlider extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ThemeData theme;
  final ColorScheme cs;

  const AudioProgressSlider({
    super.key,
    required this.ctrl,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = ctrl.duration.inMilliseconds > 0
        ? ctrl.duration.inMilliseconds.toDouble()
        : 1.0;
    final currentMs = ctrl.position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            activeTrackColor: cs.primary,
            inactiveTrackColor: theme.dividerColor.withValues(alpha: 0.6),
            thumbColor: cs.primary,
            overlayColor: cs.primary.withValues(alpha: 0.15),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            min: 0.0,
            max: maxMs,
            value: currentMs,
            onChanged: ctrl.hasPreparedAudio
                ? (v) => ctrl.seek(Duration(milliseconds: v.toInt()))
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ctrl.formatDuration(ctrl.position),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.75),
                ),
              ),
              Text(
                ctrl.formatDuration(ctrl.duration),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
