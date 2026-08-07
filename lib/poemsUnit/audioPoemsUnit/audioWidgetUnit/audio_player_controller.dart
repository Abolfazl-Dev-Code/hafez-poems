// ignore_for_file: empty_catches
import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/Initializers_and_Boot/globals.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/security/trusted_media_host.dart';
import 'package:hafez_poems/core/utils/connectivity_checker.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/recitation_service.dart';

part 'audio_player_listeners.dart';
part 'audio_player_load.dart';
part 'audio_player_source_control.dart';
part 'audio_player_recitations.dart';

enum HafezPlayerState {
  idle, // هیچ فایل فعالی وجود ندارد
  loading, // در حال آماده‌سازی فایل
  ready, // فایل آماده پخش است
  paused, // پخش متوقف شده (Pause)
  playing, // در حال پخش
}

enum _AudioIssue { noInternet, noAudioFile, slowConnection, ganjoorServerError }

enum _AudioAvailability { available, notFound, noInternet, slow, serverError }

class AudioPlayerController extends ChangeNotifier {
  bool _disposed = false;

  String? _lastId;
  String? _lastAudioUrl;
  String _lastTitle = '';
  Future<String> Function(String id)? _lastFetchAudioUrl;

  String? get lastId => _lastId;
  String? get lastAudioUrl => _lastAudioUrl;

  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;
  static const List<double> supportedSpeeds = [0.5, 1.0, 1.5, 2.0];

  List<RecitationInfo> _recitations = [];
  RecitationInfo? _selectedRecitation;
  bool _isLoadingRecitations = false;

  List<RecitationInfo> get recitations => _recitations;
  RecitationInfo? get selectedRecitation => _selectedRecitation;
  bool get isLoadingRecitations => _isLoadingRecitations;
  bool get hasMultipleRecitations => _recitations.length > 1;

  final _recitationService = RecitationService();
  final IAudioDownloadStorage _storage = Get.find<IAudioDownloadStorage>();

  HafezPlayerState _state = HafezPlayerState.idle;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  HafezPlayerState get state => _state;
  bool get hasPreparedAudio =>
      _state == HafezPlayerState.ready ||
      _state == HafezPlayerState.paused ||
      _state == HafezPlayerState.playing;

  bool get isLoadingAudio => _state == HafezPlayerState.loading;
  bool get isPlaying => _state == HafezPlayerState.playing;
  bool get isIdle => _state == HafezPlayerState.idle;
  bool _lastIsLocalFile = false;
  bool _isUsingOfflineAudio = false;
  bool get isUsingOfflineAudio => _isUsingOfflineAudio;

  String? get selectedReciterKey {
    final recitation = _selectedRecitation;
    if (recitation == null) return null;

    return ReciterKey.from(recitation.audioArtist);
  }

  void Function(String message)? onUserMessage;

  int _loadGeneration = 0;

  StreamSubscription<PlaybackState>? _playbackSub;
  StreamSubscription<MediaItem?>? _mediaSub;

  static const MethodChannel _channel = MethodChannel('hafez/audio');

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  VoidCallback? _onPositionChanged;

  void setPositionCallback(VoidCallback? callback) {
    _onPositionChanged = callback;
  }

  Future<void> playFromPrepared() async {
    await playOrPause();
  }

  PlaybackState? _lastPlaybackState;
  Timer? _positionTicker;
  static const _tickInterval = Duration(milliseconds: 50);

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
      isLocalFile: _lastIsLocalFile,
    );
  }

  Future<void> togglePlayPause() async {
    await playOrPause();
  }

  Future<void> stop() async {
    if (_disposed) return;

    try {
      await audioHandler.stop();

      _stopTicker();

      position = Duration.zero;

      _state = HafezPlayerState.ready;

      _onPositionChanged?.call();
      _notify();
    } catch (_) {}
  }

  void updateSelectedReciterByKey(String reciterKey) {
    final match = _recitations.where(
      (r) => ReciterKey.from(r.audioArtist) == reciterKey,
    );

    if (match.isEmpty) return;

    _selectedRecitation = match.first;
    _notify();
  }

  Future<void> release() async {
    try {
      await audioHandler.release();

      _stopTicker();

      _state = HafezPlayerState.idle;
      _isUsingOfflineAudio = false;

      duration = Duration.zero;
      position = Duration.zero;

      await _setSpeaker(false);

      _notify();
    } catch (_) {}
  }

  Future<void> seek(Duration pos) async {
    if (_disposed || !hasPreparedAudio) return;

    try {
      await audioHandler.seek(pos);
      position = pos;
      _onPositionChanged?.call();
      _notify();
    } catch (e) {}
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (_disposed) return;
    _playbackSpeed = speed;
    try {
      await audioHandler.customAction('setSpeed', {'speed': speed});
    } catch (e) {}
    _notify();
  }

  bool get hasAudio =>
      _recitations.isNotEmpty ||
      (_lastAudioUrl != null && _lastAudioUrl!.isNotEmpty);

  @override
  void dispose() {
    _loadGeneration++;

    _stopTicker();
    _playbackSub?.cancel();
    _mediaSub?.cancel();

    _playbackSub = null;
    _mediaSub = null;

    unawaited(release());
    _disposed = true;

    super.dispose();
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$m:$s';
  }
}
