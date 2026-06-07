import 'package:flutter/material.dart';

class ThemeRevealService {
  ThemeRevealService._();
  static final instance = ThemeRevealService._();

  final GlobalKey repaintKey = GlobalKey();
  OverlayEntry? _entry;

  Future<void> reveal({
    required BuildContext context,
    required Offset origin,
    required bool toDark,
    required VoidCallback onSwitch,
  }) async {
    if (_entry != null) return;

    final overlay = Overlay.of(context);
    onSwitch();

    _entry = OverlayEntry(
      builder: (_) => _FadeRevealOverlay(
        toDark: toDark,
        onComplete: () {
          _entry?.remove();
          _entry = null;
        },
      ),
    );

    overlay.insert(_entry!);
  }
}

// ── Overlay ───────────────────────────────────────────────────────────────────

class _FadeRevealOverlay extends StatefulWidget {
  const _FadeRevealOverlay({required this.toDark, required this.onComplete});

  final bool toDark;
  final VoidCallback onComplete;

  @override
  State<_FadeRevealOverlay> createState() => _FadeRevealOverlayState();
}

class _FadeRevealOverlayState extends State<_FadeRevealOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.toDark
        ? const Color(0xFFF2F2F7)
        : const Color(0xFF1C1C1E);

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) {
        return IgnorePointer(
          child: Opacity(
            opacity: _opacity.value,
            child: Container(color: color),
          ),
        );
      },
    );
  }
}
