import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class PoemReaderController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  Future<void> toggleAudio(String url) async {
    try {
      if (isPlaying.value) {
        await _audioPlayer.pause();
        isPlaying.value = false;
      } else {
        await _audioPlayer.play(UrlSource(url));
        isPlaying.value = true;
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
