import 'package:get/get.dart';

class PoemReaderController extends GetxController {
  var isPlaying = false.obs;
  Future<void> toggleAudio(String url) async {
    try {
      if (isPlaying.value) {
        isPlaying.value = false;
      } else {
        isPlaying.value = true;
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
