import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';

import 'package:hafez_poems/main.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/services/recitation_service.dart'; // audioHandler

/// وضعیت ساده‌شده پلیر — جایگزین PlayerState از audioplayers
enum HafezPlayerState { stopped, loading, paused, playing }

class AudioPlayerController extends ChangeNotifier {
  bool _disposed = false;

  // ── آخرین بار لود شده ──
  String? _lastId;
  String? _lastAudioUrl;
  String _lastTitle = '';
  Future<String> Function(String id)? _lastFetchAudioUrl;

  String? get lastId => _lastId;
  String? get lastAudioUrl => _lastAudioUrl;

  //edited
  // ── سرعت پخش ──
  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;
  static const List<double> supportedSpeeds = [0.5, 1.0, 1.5, 2.0];

  // ── خواننده انتخاب‌شده ──
  List<RecitationInfo> _recitations = [];
  RecitationInfo? _selectedRecitation;
  bool _isLoadingRecitations = false;

  List<RecitationInfo> get recitations => _recitations;
  RecitationInfo? get selectedRecitation => _selectedRecitation;
  bool get isLoadingRecitations => _isLoadingRecitations;
  bool get hasMultipleRecitations => _recitations.length > 1;

  final _recitationService = RecitationService();
  //edited

  // ── وضعیت ──
  HafezPlayerState _state = HafezPlayerState.stopped;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  HafezPlayerState get state => _state;

  bool get isAudioLoaded =>
      _state == HafezPlayerState.paused || _state == HafezPlayerState.playing;

  bool get isLoadingAudio => _state == HafezPlayerState.loading;

  bool get isPlaying => _state == HafezPlayerState.playing;

  bool get isStopped => _state == HafezPlayerState.stopped;

  // ── subscriptions ──
  StreamSubscription<PlaybackState>? _playbackSub;
  StreamSubscription<MediaItem?>? _mediaSub;

  static const MethodChannel _channel = MethodChannel('hafez/audio');

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // ───────────────── setup ─────────────────
  VoidCallback? _onPositionChanged;

  void setPositionCallback(VoidCallback? callback) {
    _onPositionChanged = callback;
  }

  /// یک‌بار در initState فراخوانی شود
  void setupListeners() {
    _playbackSub?.cancel();
    _mediaSub?.cancel();

    // ── playbackState stream ──
    _playbackSub = audioHandler.playbackState.listen((state) {
      if (_disposed) return;

      final processingState = state.processingState;

      // loading / buffering
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        _state = HafezPlayerState.loading;
        position = state.updatePosition;
        _onPositionChanged?.call(); // ← اضافه کن
        _notify();
        return;
      }

      // idle
      if (processingState == AudioProcessingState.idle) {
        _state = HafezPlayerState.stopped;
        position = Duration.zero;
        duration = Duration.zero;
        _notify();
        return;
      }

      // error
      if (processingState == AudioProcessingState.error) {
        _state = HafezPlayerState.stopped;
        _notify();
        return;
      }

      // completed
      // اگر handler درست پیاده شده باشد، خودش seek(0)+pause می‌کند.
      // ولی برای اطمینان اینجا هم position را صفر می‌کنیم.
      if (processingState == AudioProcessingState.completed) {
        _state = HafezPlayerState.paused;
        position = Duration.zero;
        _notify();
        return;
      }

      // ready و بقیه حالت‌های عادی
      _state = state.playing
          ? HafezPlayerState.playing
          : HafezPlayerState.paused;

      position = state.updatePosition;
      _notify();
    });

    // ── mediaItem stream — duration ──
    _mediaSub = audioHandler.mediaItem.listen((media) {
      if (_disposed) return;
      if (media == null) return;

      duration = media.duration ?? Duration.zero;
      _notify();
    });
  }

  // ───────────────── speaker ─────────────────

  Future<void> _setSpeaker(bool on) async {
    try {
      await _channel.invokeMethod(on ? 'setSpeakerOn' : 'setSpeakerOff');
    } catch (e) {
      debugPrint('⚠️ Speaker route error: $e');
    }
  }

  // ───────────────── load ─────────────────

  Future<void> load({
    required String id,
    required String audioUrl,
    String title = 'شعر حافظ',
    Future<String> Function(String id)? fetchAudioUrl,
  }) async {
    _lastId = id;
    _lastAudioUrl = audioUrl;
    _lastTitle = title;
    _lastFetchAudioUrl = fetchAudioUrl;

    if (_disposed) return;

    _state = HafezPlayerState.loading;
    duration = Duration.zero;
    position = Duration.zero;
    _notify();

    String url = audioUrl;

    if (url.isEmpty && fetchAudioUrl != null) {
      try {
        url = await fetchAudioUrl(id).timeout(const Duration(seconds: 10));
        _lastAudioUrl = url;
      } catch (e) {
        debugPrint('❌ fetchAudioUrl error: $e');
      }
    }

    if (_disposed) return;

    if (url.isEmpty) {
      debugPrint('❌ URL خالی است');
      _state = HafezPlayerState.stopped;
      _notify();
      return;
    }

    try {
      await audioHandler.customAction('load', {'url': url, 'title': title});
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _setSpeaker(true);
    } catch (e) {
      debugPrint('❌ خطا در load: $e');
      _state = HafezPlayerState.stopped;
      _notify();
    }
  }

  Future<void> reload() async {
    if (_lastId == null) return;

    String url = _lastAudioUrl ?? '';

    if (url.isEmpty && _lastFetchAudioUrl == null) {
      return;
    }

    await load(
      id: _lastId!,
      audioUrl: url,
      title: _lastTitle.isNotEmpty ? _lastTitle : 'شعر حافظ',
      fetchAudioUrl: _lastFetchAudioUrl,
    );
  }

  // ───────────────── play / pause ─────────────────

  Future<void> togglePlayPause() async {
    if (_disposed || !isAudioLoaded) return;

    try {
      if (isPlaying) {
        await audioHandler.pause();
      } else {
        await audioHandler.play();
      }

      // state از listener آپدیت می‌شود
    } catch (e) {
      debugPrint('❌ togglePlayPause error: $e');
    }
  }

  // ───────────────── stop ─────────────────

  /// توقف و برگشت به ابتدا — audio unload نمی‌شود
  Future<void> stop() async {
    if (_disposed) return;

    try {
      await audioHandler.stop();
      await _setSpeaker(false);

      // برای واکنش سریع UI
      _state = HafezPlayerState.paused;
      position = Duration.zero;
      _notify();
    } catch (e) {
      debugPrint('❌ stop error: $e');
    }
  }

  // ───────────────── seek ─────────────────

  Future<void> seek(Duration pos) async {
    if (_disposed || !isAudioLoaded) return;

    try {
      await audioHandler.seek(pos);
      position = pos;
      _notify();
    } catch (e) {
      debugPrint('❌ seek error: $e');
    }
  }

  //edited
  // ───────────────── playback speed ─────────────────

  Future<void> setPlaybackSpeed(double speed) async {
    if (_disposed) return;
    _playbackSpeed = speed;
    try {
      await audioHandler.customAction('setSpeed', {'speed': speed});
    } catch (e) {
      debugPrint('❌ setSpeed error: $e');
    }
    _notify();
  }

  // ───────────────── recitations ─────────────────

  /// دریافت لیست خوانندگان و انتخاب خواننده ذخیره‌شده (اگر موجود)
  Future<void> loadRecitations(String poemId) async {
    if (_disposed) return;

    _isLoadingRecitations = true;
    _recitations = [];
    _notify();

    try {
      // خواننده ذخیره‌شده قبلی را بررسی کن
      final saved = await _recitationService.loadSelectedRecitation(poemId);

      // لیست همه خوانندگان را دریافت کن
      final list = await _recitationService.fetchRecitations(poemId);
      if (_disposed) return;

      _recitations = list;

      if (list.isNotEmpty) {
        // اگر انتخاب ذخیره‌شده هنوز در لیست است، همان را بزن
        if (saved != null && list.any((r) => r.id == saved.id)) {
          _selectedRecitation = list.firstWhere((r) => r.id == saved.id);
        } else {
          _selectedRecitation = list.first;
        }
      } else {
        _selectedRecitation = null;
      }
    } catch (e) {
      debugPrint('❌ loadRecitations error: $e');
    } finally {
      if (!_disposed) {
        _isLoadingRecitations = false;
        _notify();
      }
    }
  }

  /// تغییر خواننده — لود مجدد صدا با URL جدید
  Future<void> selectRecitation(
    String poemId,
    RecitationInfo recitation,
  ) async {
    if (_disposed) return;

    _selectedRecitation = recitation;
    _notify();

    // ذخیره انتخاب
    await _recitationService.saveSelectedRecitation(poemId, recitation);

    // لود صدا با خواننده جدید
    await load(id: poemId, audioUrl: recitation.mp3Url, title: _lastTitle);
  }

  /// آیا فایل صوتی برای این شعر اصلاً وجود دارد
  bool get hasAudio =>
      _recitations.isNotEmpty ||
      (_lastAudioUrl != null && _lastAudioUrl!.isNotEmpty);
  //edited

  // ───────────────── dispose ─────────────────

  @override
  void dispose() {
    _disposed = true;

    _playbackSub?.cancel();
    _mediaSub?.cancel();

    _playbackSub = null;
    _mediaSub = null;

    _setSpeaker(false);

    super.dispose();
  }

  // ───────────────── helper ─────────────────

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$m:$s';
  }
}
