import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_audio_controller.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';

class BiographyAudioButtonPage extends StatefulWidget {
  const BiographyAudioButtonPage({super.key});

  @override
  State<BiographyAudioButtonPage> createState() =>
      _BiographyAudioButtonPageState();
}

class _BiographyAudioButtonPageState extends State<BiographyAudioButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BiographyColors.night,
      body: Center(
        child: FloatingActionButton(
          heroTag: 'audio',
          backgroundColor: BiographyColors.panel,
          onPressed: () {
            setState(() {});

            if (BiographyAudioController.isPlaying) {
              BiographyAudioController.pause();
            } else {
              BiographyAudioController.play();
            }
          },
          child: Icon(
            BiographyAudioController.isPlaying
                ? Icons.volume_up
                : Icons.volume_off,
            color: BiographyColors.gold,
          ),
        ),
      ),
    );
  }
}
