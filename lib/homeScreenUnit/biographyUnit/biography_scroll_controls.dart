part of 'biography_screen.dart';

extension _BiographyScrollControls on _HafezBiographyScreenState {
  void _setState(VoidCallback fn) {
    if (mounted) {
      (this as dynamic).setState(fn);
    }
  }

  void _showControls() {
    _hideControlsTimer?.cancel();
    if (!_controlsVisible && mounted) {
      _setState(() => _controlsVisible = true);
    }
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(
      _HafezBiographyScreenState._hideControlsDelay,
      () {
        _setState(() => _controlsVisible = false);
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

    _setState(() => _autoScrolling = true);
    _scheduleHideControls();

    try {
      await _scrollCtrl.animateTo(
        max,
        duration: Duration(milliseconds: ms),
        curve: Curves.linear,
      );
    } catch (_) {}

    _setState(() => _autoScrolling = false);
  }

  void _stopAutoScroll() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(_scrollCtrl.offset);
    _setState(() => _autoScrolling = false);
    _showControls();
  }

  void _toggleAutoScroll() {
    HapticFeedback.lightImpact();
    _autoScrolling ? _stopAutoScroll() : _startAutoScroll();
  }
}
