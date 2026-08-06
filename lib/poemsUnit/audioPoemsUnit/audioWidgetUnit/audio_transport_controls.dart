import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_player_controller.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_play_pause_button.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioWidgetUnit/audio_speed_widget.dart';

class AudioTransportControls extends StatelessWidget {
  final AudioPlayerController ctrl;
  final ThemeData theme;
  final ColorScheme cs;
  final Future<void> Function() onPlayPauseTap;

  const AudioTransportControls({
    super.key,
    required this.ctrl,
    required this.theme,
    required this.cs,
    required this.onPlayPauseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined),
                iconSize: 40,
                color: ctrl.hasPreparedAudio ? cs.error : theme.disabledColor,
                onPressed: ctrl.hasPreparedAudio ? ctrl.stop : null,
                tooltip: 'توقف',
              ),
              const SizedBox(width: 22),
              PlayPauseButton(
                ctrl: ctrl,
                cs: cs,
                theme: theme,
                onTap: onPlayPauseTap,
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          child: SpeedButtons(ctrl: ctrl, cs: cs, theme: theme),
        ),
      ],
    );
  }
}
