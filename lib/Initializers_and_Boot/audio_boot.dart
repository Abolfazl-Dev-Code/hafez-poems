import 'package:audio_service/audio_service.dart';
import 'package:hafez_poems/Initializers_and_Boot/globals.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audio_handler_service.dart';

class AudioBoot {
  static Future<void> init() async {
    audioHandler = await AudioService.init(
      builder: () => HafezAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.hafez.poems.audio',
        androidNotificationChannelName: 'Hafez Audio',
        androidNotificationOngoing: true,
      ),
    );
  }
}
