part of 'audio_player_controller.dart';

extension AudioPlayerLoad on AudioPlayerController {
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
        // ignore: empty_catches
      } catch (e) {}
    }

    if (_disposed || myGeneration != _loadGeneration) return;

    if (url.isEmpty || !isTrustedMediaUrl(url)) {
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
}
