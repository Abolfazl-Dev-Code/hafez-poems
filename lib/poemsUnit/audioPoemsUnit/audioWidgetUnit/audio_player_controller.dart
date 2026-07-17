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
import 'package:hafez_poems/core/utils/connectivity_checker.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_messages.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/recitation_service.dart';

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

  void setupListeners() {
    _playbackSub?.cancel();
    _mediaSub?.cancel();

    _playbackSub = audioHandler.playbackState.listen((state) {
      if (_disposed) return;

      _lastPlaybackState = state;
      final processingState = state.processingState;

      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        _state = HafezPlayerState.loading;
        position = state.position;
        _onPositionChanged?.call();
        _notify();
        return;
      }

      if (processingState == AudioProcessingState.idle) {
        _state = HafezPlayerState.idle;
        position = Duration.zero;
        duration = Duration.zero;
        _stopTicker();
        _notify();
        return;
      }

      if (processingState == AudioProcessingState.error) {
        _state = HafezPlayerState.idle;
        _stopTicker();
        _notify();
        return;
      }

      if (processingState == AudioProcessingState.completed) {
        _state = HafezPlayerState.paused;
        position = Duration.zero;
        _stopTicker();
        _onPositionChanged?.call();
        _notify();
        return;
      }

      if (processingState == AudioProcessingState.ready) {
        _state = state.playing
            ? HafezPlayerState.playing
            : HafezPlayerState.ready;
      } else {
        _state = state.playing
            ? HafezPlayerState.playing
            : HafezPlayerState.paused;
      }

      position = state.position;

      if (state.playing) {
        _startTicker();
      } else {
        _stopTicker();
      }

      _onPositionChanged?.call();
      _notify();
    });

    _mediaSub = audioHandler.mediaItem.listen((media) {
      if (_disposed) return;
      if (media == null) return;

      duration = media.duration ?? Duration.zero;
      _notify();
    });
  }

  void _startTicker() {
    if (_positionTicker != null) return;
    _positionTicker = Timer.periodic(_tickInterval, (_) {
      if (_disposed || _lastPlaybackState == null) return;
      position = _lastPlaybackState!.position;
      _onPositionChanged?.call();
      _notify();
    });
  }

  void _stopTicker() {
    _positionTicker?.cancel();
    _positionTicker = null;
  }

  Future<void> _setSpeaker(bool on) async {
    try {
      await _channel.invokeMethod(on ? 'setSpeakerOn' : 'setSpeakerOff');
    } catch (e) {}
  }

  Future<_AudioAvailability> _checkAudioAvailability(String url) async {
    HttpClient? client;
    try {
      client = HttpClient()..connectionTimeout = const Duration(seconds: 6);

      final uri = Uri.parse(url);
      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 6));
      request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-1');

      final response = await request.close().timeout(
        const Duration(seconds: 6),
      );

      await response.drain<void>();

      if (response.statusCode == 200 || response.statusCode == 206) {
        return _AudioAvailability.available;
      }
      if (response.statusCode == 404 || response.statusCode == 410) {
        return _AudioAvailability.notFound;
      }
      return _AudioAvailability.serverError;
    } on HandshakeException catch (_) {
      return _AudioAvailability.serverError;
    } on SocketException catch (_) {
      return _AudioAvailability.noInternet;
    } on TimeoutException catch (_) {
      return _AudioAvailability.slow;
    } catch (_) {
      return _AudioAvailability.serverError;
    } finally {
      client?.close(force: true);
    }
  }

  void _reportIssue(_AudioIssue issue) {
    if (_disposed) return;
    onUserMessage?.call(_messageFor(issue));
  }

  String _messageFor(_AudioIssue issue) {
    switch (issue) {
      case _AudioIssue.noInternet:
        return 'خطا در اتصال به اینترنت';
      case _AudioIssue.noAudioFile:
        return 'متأسفانه فایل صوتی برای شعر مورد نظر موجود نیست';
      case _AudioIssue.slowConnection:
        return 'اتصال شما به اینترنت ضعیف است، لطفاً کمی صبور باشید';
      case _AudioIssue.ganjoorServerError:
        return 'مشکلی در سایت گنجور پیش آمده است';
    }
  }

  Future<void> load({
    required String id,
    required String audioUrl,
    String title = 'شعر حافظ',
    Future<String> Function(String id)? fetchAudioUrl,
    bool isLocalFile = false,
  }) async {
    _lastId = id;
    _lastIsLocalFile = isLocalFile;
    _isUsingOfflineAudio = isLocalFile;
    _lastTitle = title;
    _lastFetchAudioUrl = fetchAudioUrl;
    _lastAudioUrl = audioUrl;

    if (_disposed) return;
    final int myGeneration = ++_loadGeneration;

    _state = HafezPlayerState.loading;
    duration = Duration.zero;
    position = Duration.zero;
    _stopTicker();
    _notify();

    if (isLocalFile) {
      try {
        await audioHandler
            .customAction('load', {
              'url': audioUrl,
              'title': title,
              'isLocalFile': true,
            })
            .timeout(const Duration(seconds: 15));

        if (_disposed || myGeneration != _loadGeneration) return;

        final session = await AudioSession.instance;
        await session.setActive(true);
        await _setSpeaker(true);
        _state = HafezPlayerState.ready;
        position = Duration.zero;
        _notify();
        _state = HafezPlayerState.ready;
        position = Duration.zero;
        _notify();
      } catch (e) {
        if (_disposed || myGeneration != _loadGeneration) return;
        _state = HafezPlayerState.idle;
        _isUsingOfflineAudio = false;
        _notify();
        _reportIssue(_AudioIssue.noAudioFile);
      }
      return;
    }

    final bool hasInternet = await ConnectivityChecker.hasInternet();
    if (_disposed || myGeneration != _loadGeneration) return;

    if (!hasInternet) {
      _state = HafezPlayerState.idle;
      _notify();
      _reportIssue(_AudioIssue.noInternet);
      return;
    }

    String url = audioUrl;
    if (url.isEmpty && fetchAudioUrl != null) {
      try {
        url = await fetchAudioUrl(id).timeout(const Duration(seconds: 10));
        _lastAudioUrl = url;
      } catch (e) {}
    }

    if (_disposed || myGeneration != _loadGeneration) return;

    if (url.isEmpty) {
      _state = HafezPlayerState.idle;
      _isUsingOfflineAudio = false;
      _notify();
      _reportIssue(_AudioIssue.noAudioFile);
      return;
    }

    final availability = await _checkAudioAvailability(url);
    if (_disposed || myGeneration != _loadGeneration) return;

    switch (availability) {
      case _AudioAvailability.notFound:
        _state = HafezPlayerState.idle;
        _isUsingOfflineAudio = false;
        _notify();
        _reportIssue(_AudioIssue.noAudioFile);
        return;
      case _AudioAvailability.noInternet:
        _state = HafezPlayerState.idle;
        _isUsingOfflineAudio = false;
        _notify();
        _reportIssue(_AudioIssue.noInternet);
        return;
      case _AudioAvailability.serverError:
        _state = HafezPlayerState.idle;
        _isUsingOfflineAudio = false;
        _notify();
        _reportIssue(_AudioIssue.ganjoorServerError);
        return;
      case _AudioAvailability.available:
      case _AudioAvailability.slow:
        break;
    }

    bool slowWarningShown = false;
    final slowTimer = Timer(const Duration(seconds: 4), () {
      if (_disposed || myGeneration != _loadGeneration) return;
      if (_state == HafezPlayerState.loading) {
        slowWarningShown = true;
        _reportIssue(_AudioIssue.slowConnection);
      }
    });

    try {
      await audioHandler
          .customAction('load', {'url': url, 'title': title})
          .timeout(const Duration(seconds: 25));

      slowTimer.cancel();
      if (_disposed || myGeneration != _loadGeneration) return;

      final session = await AudioSession.instance;
      await session.setActive(true);
      await _setSpeaker(true);
    } catch (e) {
      slowTimer.cancel();
      if (_disposed || myGeneration != _loadGeneration) return;

      _state = HafezPlayerState.idle;
      _notify();

      final msg = e.toString();

      final isNetworkDropped =
          msg.contains('SocketException') || msg.contains('Failed host lookup');

      final isCertOrServerIssue =
          msg.contains('CertificateException') ||
          msg.contains('HandshakeException') ||
          msg.contains('SSLHandshakeException') ||
          msg.contains('Source error') ||
          msg.contains('SourceException') ||
          msg.contains('ExoPlaybackException');

      if (isNetworkDropped) {
        _reportIssue(_AudioIssue.noInternet);
      } else if (isCertOrServerIssue) {
        _reportIssue(_AudioIssue.ganjoorServerError);
      } else if (!slowWarningShown) {
        _reportIssue(_AudioIssue.ganjoorServerError);
      }
    }
  }

  Future<bool> switchToOnlineVersion() async {
    if (_disposed) return false;

    final recitation = _selectedRecitation;
    final id = _lastId;

    if (recitation == null || id == null) {
      await release();
      return false;
    }

    final hasInternet = await ConnectivityChecker.hasInternet();

    if (!hasInternet) {
      await release();
      _reportIssue(_AudioIssue.noInternet);
      return false;
    }

    _lastIsLocalFile = false;
    _isUsingOfflineAudio = false;

    await load(
      id: id,
      audioUrl: recitation.mp3Url,
      title: _lastTitle,
      fetchAudioUrl: _lastFetchAudioUrl,
      isLocalFile: false,
    );

    if (!hasPreparedAudio) {
      await release();
      return false;
    }

    AppSnackBarService.success(
      'فایل آفلاین حذف شد؛ نسخه آنلاین فعال شد.',
      duration: const Duration(seconds: 3),
    );

    return true;
  }

  Future<void> playOrPause() async {
    if (_disposed) return;

    switch (_state) {
      case HafezPlayerState.idle:
        if (_lastId == null) return;

        await load(
          id: _lastId!,
          audioUrl: _lastAudioUrl ?? '',
          title: _lastTitle,
          fetchAudioUrl: _lastFetchAudioUrl,
          isLocalFile: _lastIsLocalFile,
        );

        if (_state == HafezPlayerState.ready) {
          await audioHandler.play();
        }
        break;

      case HafezPlayerState.ready:
        await audioHandler.play();
        break;

      case HafezPlayerState.paused:
        await audioHandler.play();
        break;

      case HafezPlayerState.playing:
        await audioHandler.pause();
        break;

      case HafezPlayerState.loading:
        break;
    }
  }

  Future<void> loadWithSourceResolution({
    required String id,
    required String poemCategory,
    required String reciterKey,
    required String onlineUrl,
    required AudioSourceResolver resolver,
    String title = 'شعر حافظ',
    void Function(String xml)? onSyncXmlResolved,
    VoidCallback? onSyncUnavailable,
  }) async {
    if (_disposed) return;
    final int myGeneration = ++_loadGeneration;

    _state = HafezPlayerState.loading;
    duration = Duration.zero;
    position = Duration.zero;
    _stopTicker();
    _notify();

    final resolution = await resolver.resolve(
      poemId: id,
      poemCategory: poemCategory,
      reciterKey: reciterKey,
      onlineUrl: onlineUrl,
    );

    if (_disposed || myGeneration != _loadGeneration) return;

    if (resolution.userMessage != null) {
      onUserMessage?.call(resolution.userMessage!);
    }

    if (resolution.kind == AudioSourceKind.unavailable) {
      _state = HafezPlayerState.idle;
      _notify();
      return;
    }

    if (resolution.kind == AudioSourceKind.local) {
      onSyncUnavailable?.call();
    } else if (resolution.syncXml != null && onSyncXmlResolved != null) {
      onSyncXmlResolved(resolution.syncXml!);
    }
    updateSelectedReciterByKey(reciterKey);
    await load(
      id: id,
      audioUrl: resolution.path,
      title: title,
      isLocalFile: resolution.kind == AudioSourceKind.local,
    );
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

  Future<void> loadRecitations(String poemId, String poemCategory) async {
    if (_disposed) return;

    _isLoadingRecitations = true;
    _recitations = [];
    _notify();

    try {
      final saved = await _recitationService.loadSelectedRecitation(poemId);
      final list = await _recitationService.fetchRecitations(poemId);
      if (_disposed) return;

      _recitations = list;

      if (list.isNotEmpty) {
        if (saved != null && list.any((r) => r.id == saved.id)) {
          _selectedRecitation = list.firstWhere((r) => r.id == saved.id);
        } else {
          final globalDefault = await _storage.getDefaultReciter(poemCategory);
          RecitationInfo? bestMatch;

          if (globalDefault != null) {
            int bestScore = 0;

            for (final reciter in list) {
              final score = ReciterKey.score(
                reciter.audioArtist,
                globalDefault.reciterDisplayName,
              );

              if (score > bestScore) {
                bestScore = score;
                bestMatch = reciter;
              }
            }
          }

          _selectedRecitation = bestMatch ?? list.first;
        }
      } else {
        _selectedRecitation = null;
      }
    } catch (e) {
    } finally {
      if (!_disposed) {
        _isLoadingRecitations = false;
        _notify();
      }
    }
  }

  Future<void> selectRecitation(
    String poemId,
    RecitationInfo recitation,
  ) async {
    if (_disposed) return;

    _selectedRecitation = recitation;
    _notify();

    await _recitationService.saveSelectedRecitation(poemId, recitation);

    await load(id: poemId, audioUrl: recitation.mp3Url, title: _lastTitle);
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
