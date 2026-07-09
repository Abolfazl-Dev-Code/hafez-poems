import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:hafez_poems/Initializers_and_Boot/globals.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/recitation_service.dart';

/// وضعیت ساده‌شده پلیر — جایگزین PlayerState از audioplayers
enum HafezPlayerState { stopped, loading, paused, playing }

/// دسته‌بندی داخلی مشکلاتی که ممکن است حین لود پیش بیاید
enum _AudioIssue { noInternet, noAudioFile, slowConnection, ganjoorServerError }

/// نتیجه‌ی بررسیِ اولیه‌ی در دسترس بودن فایل صوتی
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

  HafezPlayerState _state = HafezPlayerState.stopped;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  HafezPlayerState get state => _state;
  bool get isAudioLoaded =>
      _state == HafezPlayerState.paused || _state == HafezPlayerState.playing;
  bool get isLoadingAudio => _state == HafezPlayerState.loading;
  bool get isPlaying => _state == HafezPlayerState.playing;
  bool get isStopped => _state == HafezPlayerState.stopped;

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

  /// پخش صوت از حالت آماده (بدون نیاز به load مجدد)
  Future<void> playFromPrepared() async {
    if (!isAudioLoaded) {
      await load(
        id: _lastId!,
        audioUrl: _lastAudioUrl ?? '',
        title: _lastTitle,
        fetchAudioUrl: _lastFetchAudioUrl,
      );
    }

    if (isAudioLoaded) {
      await togglePlayPause();
    }
  }

  /// آخرین وضعیت پخش‌کننده
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
        _state = HafezPlayerState.stopped;
        position = Duration.zero;
        duration = Duration.zero;
        _stopTicker();
        _notify();
        return;
      }

      if (processingState == AudioProcessingState.error) {
        _state = HafezPlayerState.stopped;
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

      _state = state.playing
          ? HafezPlayerState.playing
          : HafezPlayerState.paused;

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

  /// تنظیم سخنگو‌ی دستگاه (اسپیکر یا هدفون)
  Future<void> _setSpeaker(bool on) async {
    try {
      await _channel.invokeMethod(on ? 'setSpeakerOn' : 'setSpeakerOff');
    } catch (e) {
      // خطا در تنظیم اسپیکر نادیده گرفته می‌شود
    }
  }

  /// بررسی اتصال مستقیم به اینترنت از طریق IP سرویس‌های معتبر
  /// این روش از DNS استفاده نمی‌کند و از فیلترینگ DNS جلوگیری می‌کند
  Future<bool> _hasInternetConnection() async {
    const probes = ['1.1.1.1', '8.8.8.8'];
    for (final ip in probes) {
      Socket? socket;
      try {
        socket = await Socket.connect(
          ip,
          443,
          timeout: const Duration(seconds: 3),
        );
        return true;
      } catch (_) {
        continue;
      } finally {
        socket?.destroy();
      }
    }
    return false;
  }

  /// بررسی وجود و دسترسی‌پذیری فایل صوتی از طریق درخواست Range
  /// این روش نسبت به HEAD بسیار گسترده‌تر پشتیبانی می‌شود
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
  }) async {
    _lastId = id;
    _lastAudioUrl = audioUrl;
    _lastTitle = title;
    _lastFetchAudioUrl = fetchAudioUrl;

    if (_disposed) return;
    final int myGeneration = ++_loadGeneration;

    _state = HafezPlayerState.loading;
    duration = Duration.zero;
    position = Duration.zero;
    _stopTicker();
    _notify();

    final bool hasInternet = await _hasInternetConnection();
    if (_disposed || myGeneration != _loadGeneration) return;

    if (!hasInternet) {
      _state = HafezPlayerState.stopped;
      _notify();
      _reportIssue(_AudioIssue.noInternet);
      return;
    }

    String url = audioUrl;
    if (url.isEmpty && fetchAudioUrl != null) {
      try {
        url = await fetchAudioUrl(id).timeout(const Duration(seconds: 10));
        _lastAudioUrl = url;
      } catch (e) {
        // خطای دریافت URL نادیده گرفته می‌شود
      }
    }

    if (_disposed || myGeneration != _loadGeneration) return;

    if (url.isEmpty) {
      _state = HafezPlayerState.stopped;
      _notify();
      _reportIssue(_AudioIssue.noAudioFile);
      return;
    }

    final availability = await _checkAudioAvailability(url);
    if (_disposed || myGeneration != _loadGeneration) return;

    switch (availability) {
      case _AudioAvailability.notFound:
        _state = HafezPlayerState.stopped;
        _notify();
        _reportIssue(_AudioIssue.noAudioFile);
        return;
      case _AudioAvailability.noInternet:
        _state = HafezPlayerState.stopped;
        _notify();
        _reportIssue(_AudioIssue.noInternet);
        return;
      case _AudioAvailability.serverError:
        _state = HafezPlayerState.stopped;
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

      _state = HafezPlayerState.stopped;
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

  Future<void> togglePlayPause() async {
    if (_disposed || !isAudioLoaded) return;

    try {
      if (isPlaying) {
        await audioHandler.pause();
      } else {
        await audioHandler.play();
      }
    } catch (e) {
      // خطا در toggle play/pause نادیده گرفته می‌شود
    }
  }

  /// توقف پخش و آزادسازی منابع
  Future<void> stop() async {
    if (_disposed) return;

    try {
      await audioHandler.stop();
      await _setSpeaker(false);
      _stopTicker();
      _state = HafezPlayerState.stopped;
      position = Duration.zero;
      _notify();
    } catch (e) {
      // خطا در توقف نادیده گرفته می‌شود
    }
  }

  /// تغییر موقعیت پخش
  Future<void> seek(Duration pos) async {
    if (_disposed || !isAudioLoaded) return;

    try {
      await audioHandler.seek(pos);
      position = pos;
      _onPositionChanged?.call();
      _notify();
    } catch (e) {
      // خطا در seek نادیده گرفته می‌شود
    }
  }

  /// تنظیم سرعت پخش
  Future<void> setPlaybackSpeed(double speed) async {
    if (_disposed) return;
    _playbackSpeed = speed;
    try {
      await audioHandler.customAction('setSpeed', {'speed': speed});
    } catch (e) {
      // خطا در تنظیم سرعت نادیده گرفته می‌شود
    }
    _notify();
  }

  /// بارگذاری لیست تلاوت‌کنندگان برای شعر
  Future<void> loadRecitations(String poemId) async {
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
          _selectedRecitation = list.first;
        }
      } else {
        _selectedRecitation = null;
      }
    } catch (e) {
      // خطا در بارگذاری تلاوت‌کنندگان نادیده گرفته می‌شود
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
    _disposed = true;
    _loadGeneration++;

    _stopTicker();
    _playbackSub?.cancel();
    _mediaSub?.cancel();

    _playbackSub = null;
    _mediaSub = null;

    _setSpeaker(false);
    audioHandler.stop();

    super.dispose();
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$m:$s';
  }
}
