part of 'audio_player_controller.dart';

extension AudioPlayerListeners on AudioPlayerController {
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
    _positionTicker = Timer.periodic(AudioPlayerController._tickInterval, (_) {
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
      await AudioPlayerController._channel.invokeMethod(
        on ? 'setSpeakerOn' : 'setSpeakerOff',
      );
      // ignore: empty_catches
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
}
