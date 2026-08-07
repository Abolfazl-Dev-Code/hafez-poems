part of 'poem_screen.dart';

extension _PoemScreenScroll on _PoemScreenState {
  void _syncPosition() {
    if (!_audioCtrl.isPlaying) return;

    _verseSyncCtrl.updatePosition(_audioCtrl.position);
  }

  void _onActiveVerseChanged() {
    if (_audioCtrl.isPlaying && _verseSyncCtrl.hasSyncData) {
      _verseSyncCtrl.updatePosition(_audioCtrl.position);
    }

    // فقط هنگام پخش
    if (!_audioCtrl.isPlaying) return;

    if (_userIsInteractingWithScroll) return;
    if (_isContextMenuOpen) return;

    final order = _verseSyncCtrl.activeVerseOrder;

    if (order < 0) return;
    if (order == _lastAutoScrolledVerseOrder) return;

    _lastAutoScrolledVerseOrder = order;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLineIndex(order);
    });
  }

  Future<void> _scrollToLineIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 450),
    double anchorFraction = 1 / 3,
  }) async {
    if (!mounted) return;
    if (_isContextMenuOpen) return;
    final key = _lineKeys[index];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !_scrollController.hasClients) return;

    final scrollBox =
        _scrollController.position.context.storageContext.findRenderObject()
            as RenderBox?;
    if (scrollBox == null || !scrollBox.attached) return;

    final tileOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
    final screenHeight = scrollBox.size.height;
    final targetOffset =
        (_scrollController.offset +
                tileOffset.dy -
                screenHeight * anchorFraction)
            .clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      targetOffset,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  void _pauseAutoScroll() {
    _resumeAutoScrollTimer?.cancel();
    _userIsInteractingWithScroll = true;
  }

  void _scheduleResumeAutoScroll() {
    _resumeAutoScrollTimer?.cancel();
    _resumeAutoScrollTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      _userIsInteractingWithScroll = false;
      _lastAutoScrolledVerseOrder = null;
      _onActiveVerseChanged();
    });
  }

  void _resumeAutoScrollImmediately() {
    _resumeAutoScrollTimer?.cancel();
    if (!mounted) return;
    _userIsInteractingWithScroll = false;
    _lastAutoScrolledVerseOrder = null;
    _onActiveVerseChanged();
  }

  void _measureBottomOverlay() {
    if (!mounted) return;
    final box =
        _bottomOverlayKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final height = box.size.height;
    _updateOverlayHeight(height);
  }

  void _scheduleMeasureBottomOverlay({Duration delay = Duration.zero}) {
    Future.delayed(delay, () {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _measureBottomOverlay(),
      );
    });
  }
}
