part of 'carousel_screen.dart';

extension _CarouselVideoController on _CarouselScreenWidgetState {
  Future<void> _initFlipVideo(bool isDark) async {
    if (_isInitializingVideo) return;
    _isInitializingVideo = true;
    try {
      _videoController?.removeListener(_onVideoTick);
      await _videoController?.dispose();
      _videoController = null;

      final asset = isDark
          ? _CarouselScreenWidgetState._flipVideoDark
          : _CarouselScreenWidgetState._flipVideoLight;
      final controller = VideoPlayerController.asset(asset);
      await controller.initialize();
      await controller.setVolume(0);
      controller.addListener(_onVideoTick);
      if (!mounted) {
        controller.dispose();
        return;
      }
      _setVideoController(controller);
    } catch (e) {
      debugPrint('Hafez flip video failed to load: $e');
    } finally {
      _isInitializingVideo = false;
    }
  }

  void _onVideoTick() {
    if (!_videoPlaying || !_showVideo) return;
    final controller = _videoController;
    if (controller == null) return;
    final value = controller.value;
    if (!value.isInitialized || value.duration == Duration.zero) return;
    if (!value.isPlaying && value.position >= value.duration) {
      _videoPlaying = false;
      _onFlipFinished();
    }
  }

  void _onFlipFinished() {
    _completionTimer?.cancel();
    _completionTimer = null;
    if (!mounted || !_isRefreshing) return;
    widget.onChangeGhazal();
    _setFlipFinishedState();
    _videoController?.seekTo(Duration.zero);
  }

  Future<void> _handleRefreshTap() async {
    if (_isRefreshing) return;
    if (_videoController == null && _videoInitFuture != null) {
      await _videoInitFuture!.timeout(
        const Duration(milliseconds: 1200),
        onTimeout: () {},
      );
    }
    final controller = _videoController;
    final videoReady = controller != null && controller.value.isInitialized;
    _setRefreshState(
      isRefreshing: true,
      showVideo: videoReady,
      videoPlaying: false,
    );

    if (!videoReady) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      widget.onChangeGhazal();
      _setRefreshing(false);
      return;
    }

    await controller.seekTo(Duration.zero);
    await Future.delayed(const Duration(milliseconds: 100));
    _videoPlaying = true;
    await controller.play();
    final duration = controller.value.duration;
    _completionTimer?.cancel();
    _completionTimer = Timer(
      duration + const Duration(milliseconds: 500),
      _onFlipFinished,
    );
  }
}
