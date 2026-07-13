import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class BiographyAudioController {
  BiographyAudioController._();

  static AudioPlayer? _player;
  static bool _isInitialized = false;
  static int _generation = 0;

  static final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);
  static bool get isPlaying => isPlayingNotifier.value;

  static Future<void> init() async {
    if (_isInitialized && _player != null) return;

    try {
      _player = AudioPlayer();
      await _player!.setAudioSource(
        AudioSource.asset('assets/audio/Jalal_Naghsh_Nilchi.mp3'),
      );
      await _player!.setLoopMode(LoopMode.one);
      await _player!.setVolume(0);

      if (_player!.playing) {
        await _player!.pause();
      }

      _isInitialized = true;
    } catch (_) {
      _isInitialized = false;
      _player = null;
    }
  }

  static Future<void> play() async {
    final myGen = ++_generation;
    isPlayingNotifier.value = true;

    await init();

    if (!_isInitialized || _player == null || myGen != _generation) return;

    try {
      await _player!.setVolume(1.0);
      await _player!.play();

      if (myGen != _generation) {
        await _player!.pause();
      }
    } catch (_) {}
  }

  static Future<void> pause() async {
    final myGen = ++_generation;
    isPlayingNotifier.value = false;

    if (_player == null) return;

    try {
      await _player!.pause();
      await _player!.setVolume(0);

      if (myGen != _generation) {
        await _player!.play();
      }
    } catch (_) {}
  }

  static Future<void> stop() async {
    _generation++;
    isPlayingNotifier.value = false;

    if (_player == null) return;

    try {
      await _player!.pause();
      await _player!.setVolume(0);
    } catch (_) {}
  }

  static Future<void> release() async {
    _generation++;
    isPlayingNotifier.value = false;

    if (_player == null) return;

    try {
      await _player!.stop();
      await _player!.dispose();
    } catch (_) {}

    _player = null;
    _isInitialized = false;
  }
}
