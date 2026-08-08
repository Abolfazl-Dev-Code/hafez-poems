import 'package:flutter/material.dart';
import 'more_menu_content.dart';

class AppBarMoreMenu extends StatefulWidget {
  final ValueNotifier<bool> isLiked;
  final ValueNotifier<bool> isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const AppBarMoreMenu({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  State<AppBarMoreMenu> createState() => _AppBarMoreMenuState();
}

class _AppBarMoreMenuState extends State<AppBarMoreMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.34, 1.56, 0.64, 1),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
    setState(() => _isOpen = true);
  }

  void _close() {
    _controller.reverse().then((_) {
      _removeOverlay();
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(5, 44),
              child: Material(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    alignment: Alignment.topLeft,
                    child: MoreMenuContent(
                      isLiked: widget.isLiked,
                      isSaved: widget.isSaved,
                      colorScheme: widget.colorScheme,
                      textTheme: widget.textTheme,
                      onLike: () {
                        widget.onLike();
                        _overlayEntry?.markNeedsBuild();
                      },
                      onSave: () {
                        widget.onSave();
                        _overlayEntry?.markNeedsBuild();
                      },
                      onShare: () {
                        _close();
                        widget.onShare();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _isOpen
                  ? widget.colorScheme.surfaceContainerHighest
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: AnimatedRotation(
              turns: _isOpen ? 0.25 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: Icon(
                Icons.more_horiz,
                size: 29,
                color: widget.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
