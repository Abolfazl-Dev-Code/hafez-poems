import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_audio_controller.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';

class BiographyAudioButton extends StatelessWidget {
  const BiographyAudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiographyAudioController.isPlayingNotifier,
      builder: (context, isPlaying, _) {
        return FloatingActionButton(
          heroTag: 'audio_btn',
          backgroundColor: BiographyColors.panel,
          onPressed: () {
            isPlaying
                ? BiographyAudioController.pause()
                : BiographyAudioController.play();
          },
          child: Icon(
            isPlaying ? Icons.volume_up : Icons.volume_off,
            color: BiographyColors.gold,
          ),
        );
      },
    );
  }
}

class BiographyAutoScrollButton extends StatelessWidget {
  final bool autoScrolling;
  final VoidCallback onToggle;

  const BiographyAutoScrollButton({
    super.key,
    required this.autoScrolling,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'scroll_btn',
      onPressed: onToggle,
      backgroundColor: BiographyColors.panel,
      child: Icon(
        autoScrolling ? Icons.pause : Icons.play_arrow,
        color: BiographyColors.gold,
      ),
    );
  }
}
