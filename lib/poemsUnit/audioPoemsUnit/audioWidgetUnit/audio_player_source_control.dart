part of 'audio_player_controller.dart';

extension AudioPlayerSourceControl on AudioPlayerController {
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
      final storedSync = resolution.syncXml;
      if (storedSync != null &&
          storedSync.isNotEmpty &&
          onSyncXmlResolved != null) {
        onSyncXmlResolved(storedSync);
      } else {
        onSyncUnavailable?.call();
      }
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
}
