import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_player_controller.dart';

class PlayPauseButton extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ColorScheme cs;
  final ThemeData theme;

  const PlayPauseButton({
    super.key,
    required this.ctrl,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = ctrl.isAudioLoaded && !ctrl.isLoadingAudio;

    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: enabled ? cs.primary : theme.disabledColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: enabled ? 0.25 : 0.0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: ctrl.isPlaying ? 'مکث' : 'پخش',
        icon: ctrl.isLoadingAudio
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: cs.onPrimary,
                ),
              )
            : Icon(
                ctrl.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 32,
              ),
        color: cs.onPrimary,
        onPressed: enabled ? ctrl.togglePlayPause : null,
      ),
    );
  }
}
