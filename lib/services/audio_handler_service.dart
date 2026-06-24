import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;

/// هندلر صدا — just_audio + audio_service
/// سینک کامل بین پلیر برنامه و نوتیفیکیشن
class HafezAudioHandler extends BaseAudioHandler with SeekHandler {
  late final ja.AudioPlayer _player;

  HafezAudioHandler() {
    _player = ja.AudioPlayer(
      audioLoadConfiguration: ja.AudioLoadConfiguration(
        androidLoadControl: ja.AndroidLoadControl(),
      ),
    );
    _configureAudioSession();
    _listenToPlayerState();
    _listenToPosition();
    _listenToDuration();
  }
  //edited
  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;
  //edited

  // ───────────────── listeners ─────────────────

  /// وضعیت پخش، pause، completed، loading و غیره
  void _listenToPlayerState() {
    _player.playerStateStream.listen((state) async {
      final processingState = _mapProcessingState(state.processingState);
      if (state.processingState == ja.ProcessingState.completed) {
        try {
          await _player.pause();
          await _player.seek(Duration.zero);
        } catch (_) {}

        playbackState.add(
          playbackState.value.copyWith(
            controls: _buildControls(false),
            playing: false,
            processingState: AudioProcessingState.ready,
            updatePosition: Duration.zero,
          ),
        );

        return;
      }

      playbackState.add(
        playbackState.value.copyWith(
          controls: _buildControls(state.playing),
          playing: state.playing,
          processingState: processingState,
        ),
      );
    });
  }

  /// موقعیت فعلی پخش
  void _listenToPosition() {
    _player.positionStream.listen((position) {
      if (_player.processingState == ja.ProcessingState.completed) {
        playbackState.add(
          playbackState.value.copyWith(updatePosition: Duration.zero),
        );
        return;
      }

      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
  }

  /// مدت زمان کل فایل
  void _listenToDuration() {
    _player.durationStream.listen((duration) {
      final item = mediaItem.value;

      if (item != null && duration != null) {
        mediaItem.add(item.copyWith(duration: duration));
      }
    });
  }

  // ───────────────── helpers ─────────────────

  AudioProcessingState _mapProcessingState(ja.ProcessingState state) {
    switch (state) {
      case ja.ProcessingState.idle:
        return AudioProcessingState.idle;

      case ja.ProcessingState.loading:
        return AudioProcessingState.loading;

      case ja.ProcessingState.buffering:
        return AudioProcessingState.buffering;

      case ja.ProcessingState.ready:
        return AudioProcessingState.ready;

      case ja.ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  List<MediaControl> _buildControls(bool playing) {
    return [
      if (playing) MediaControl.pause else MediaControl.play,
      MediaControl.stop,
      MediaControl.rewind,
      MediaControl.fastForward,
    ];
  }

  // ───────────────── audio session ─────────────────
  // داخل کلاس HafezAudioHandler
  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    debugPrint('🎵 customAction called: $name'); // این لاگ مهم است
    switch (name) {
      case 'load':
        final url = extras?['url'] as String?;
        final title = extras?['title'] as String?;
        debugPrint('🎵 Loading URL: $url');
        await load(url!, title: title);
        return null;
      //edited
      case 'setSpeed':
        final speed = (extras?['speed'] as num?)?.toDouble() ?? 1.0;
        await setSpeed(speed);
        return null;
      //edited
      default:
        return super.customAction(name, extras);
    }
  }

  // Future<void> _configureAudioSession() async {
  //   final session = await AudioSession.instance;

  //   await session.configure(
  //     const AudioSessionConfiguration(
  //       avAudioSessionCategory: AVAudioSessionCategory.playback,
  //       avAudioSessionCategoryOptions:
  //           AVAudioSessionCategoryOptions.mixWithOthers,
  //       androidAudioAttributes: AndroidAudioAttributes(
  //         contentType: AndroidAudioContentType.music,
  //         usage: AndroidAudioUsage.media,
  //         flags: AndroidAudioFlags.none,
  //       ),
  //       androidAudioFocusGainType:
  //           AndroidAudioFocusGainType.gainTransientMayDuck,
  //       androidWillPauseWhenDucked: false,
  //     ),
  //   );
  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
          flags: AndroidAudioFlags.none,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain, // ← تغییر
        androidWillPauseWhenDucked: true, // ← تغییر
      ),
    );

    // بعد از تموم شدن تماس، ادامه پخش
    bool wasPlaying = false;
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        wasPlaying = _player.playing;
      } else {
        if (wasPlaying) {
          play(); // ← از همین متد که seek داره استفاده کن
        }
      }
    });
  }

  // ───────────────── public API ─────────────────

  /// بارگذاری فایل صوتی جدید
  Future<void> load(String url, {String? title}) async {
    // final session = await AudioSession.instance;
    // await session.setActive(true); // ← اینجا اضافه کن
    mediaItem.add(
      MediaItem(id: url, title: title ?? 'Hafez Poems', artist: 'اشعار حافظ'),
    );

    playbackState.add(
      playbackState.value.copyWith(
        controls: _buildControls(false),
        processingState: AudioProcessingState.loading,
        playing: false,
        updatePosition: Duration.zero,
      ),
    );

    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.seek(Duration.zero);

      playbackState.add(
        playbackState.value.copyWith(
          controls: _buildControls(false),
          processingState: AudioProcessingState.ready,
          playing: false,
          updatePosition: Duration.zero,
        ),
      );
    } catch (e) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: _buildControls(false),
          processingState: AudioProcessingState.error,
          playing: false,
          updatePosition: Duration.zero,
        ),
      );

      rethrow;
    }
  }

  //edited
  @override
  Future<void> setSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.25, 2.0);
    await _player.setSpeed(_playbackSpeed);
  }
  //edited

  // @override
  // Future<void> play() async {
  // force ExoPlayer به rebuild کردن AudioTrack با routing فعلی
  //   await _player.seek(_player.position);
  //   await _player.play();
  // }
  @override
  Future<void> play() async {
    final session = await AudioSession.instance;
    await session.setActive(true); // ← اینجا، نه توی load
    await _player.seek(_player.position);
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    playbackState.add(
      playbackState.value.copyWith(
        controls: _buildControls(false),
        playing: false,
        updatePosition: _player.position,
      ),
    );
  }

  // @override
  // Future<void> stop() async {
  //   await _player.pause();
  //   await _player.seek(Duration.zero);
  //   playbackState.add(
  //     playbackState.value.copyWith(
  //       controls: _buildControls(false),
  //       processingState: AudioProcessingState.ready,
  //       playing: false,
  //       updatePosition: Duration.zero,
  //     ),
  //   );
  // }
  @override
  Future<void> stop() async {
    await _player.pause();
    await _player.seek(Duration.zero);

    // session رو آزاد کن
    final session = await AudioSession.instance;
    await session.setActive(false); // ← این خط اضافه کن

    playbackState.add(
      playbackState.value.copyWith(
        controls: _buildControls(false),
        processingState: AudioProcessingState.ready,
        playing: false,
        updatePosition: Duration.zero,
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);

    final session = await AudioSession.instance;
    await session.setActive(true); // ← focus رو دوباره بگیر

    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> rewind() async {
    final current = _player.position;
    final target = current - const Duration(seconds: 10);

    if (target < Duration.zero) {
      await seek(Duration.zero);
    } else {
      await seek(target);
    }
  }

  @override
  Future<void> fastForward() async {
    final current = _player.position;
    final duration = _player.duration ?? Duration.zero;
    final target = current + const Duration(seconds: 10);

    if (duration == Duration.zero) {
      return;
    }

    if (target > duration) {
      await seek(duration);
    } else {
      await seek(target);
    }
  }

  /// آزادسازی منابع
  Future<void> disposePlayer() async {
    await _player.dispose();
  }
}
