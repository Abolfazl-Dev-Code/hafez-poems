part of 'audio_handler_service.dart';

extension _AudioHandlerListeners on HafezAudioHandler {
  // ───────────────── listeners ─────────────────
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
}
