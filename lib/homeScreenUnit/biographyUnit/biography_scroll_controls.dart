part of 'biography_screen.dart';

extension _BiographyScrollControls on _HafezBiographyScreenState {
  void _showControls() {
    _hideControlsTimer?.cancel();
    if (!_controlsVisible && mounted) {
      _setControlsVisible(true);
    }
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(
      _HafezBiographyScreenState._hideControlsDelay,
      () {
        if (mounted) _setControlsVisible(false);
      },
    );
  }

  Future<void> _startAutoScroll() async {
    if (!mounted || !_scrollCtrl.hasClients) return;

    final max = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.offset;

    if (max <= 0 || current >= max) return;

    final remaining = max - current;
    const double scrollSpeed = 30.0;

    final ms = (remaining / scrollSpeed * 1000).round().clamp(3000, 120000);

    _setAutoScrolling(true);
    _scheduleHideControls();

    try {
      await _scrollCtrl.animateTo(
        max,
        duration: Duration(milliseconds: ms),
        curve: Curves.linear,
      );
    } catch (_) {}

    if (mounted) _setAutoScrolling(false);
  }

  void _stopAutoScroll() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(_scrollCtrl.offset);
    if (mounted) _setAutoScrolling(false);
    _showControls();
  }

  void _toggleAutoScroll() {
    HapticFeedback.lightImpact();
    _autoScrolling ? _stopAutoScroll() : _startAutoScroll();
  }
}
