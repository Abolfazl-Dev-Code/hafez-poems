import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

    final boundary =
        repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      onSwitch();
      return;
    }

    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final ui.Image snapshot = await boundary.toImage(pixelRatio: pixelRatio);
    final maxRadius = _maxRadiusFromOrigin(origin, size);

    _entry = OverlayEntry(
      builder: (_) => _CircleRevealOverlay(
        snapshot: snapshot,
        screenSize: size,
        pixelRatio: pixelRatio,
        origin: origin,
        maxRadius: maxRadius,
        toDark: toDark,
        onComplete: () {
          _entry?.remove();
          _entry = null;
          snapshot.dispose();
        },
      ),
    );

    overlay.insert(_entry!);
    WidgetsBinding.instance.addPostFrameCallback((_) => onSwitch());
  }

  double _maxRadiusFromOrigin(Offset origin, Size size) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    double maxDist = 0;
    for (final corner in corners) {
      final dist = (origin - corner).distance;
      if (dist > maxDist) maxDist = dist;
    }
    return maxDist;
  }
}

// ── Overlay ───────────────────────────────────────────────────────────────────

class _CircleRevealOverlay extends StatefulWidget {
  const _CircleRevealOverlay({
    required this.snapshot,
    required this.screenSize,
    required this.pixelRatio,
    required this.origin,
    required this.maxRadius,
    required this.toDark,
    required this.onComplete,
  });

  final ui.Image snapshot;
  final Size screenSize;
  final double pixelRatio;
  final Offset origin;
  final double maxRadius;
  final bool toDark;
  final VoidCallback onComplete;

  @override
  State<_CircleRevealOverlay> createState() => _CircleRevealOverlayState();
}

class _CircleRevealOverlayState extends State<_CircleRevealOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _radius;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _radius = Tween<double>(
      begin: widget.toDark ? widget.maxRadius : 0,
      end: widget.toDark ? 0 : widget.maxRadius,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic));

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
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _radius,
        builder: (context, _) {
          return CustomPaint(
            size: widget.screenSize,
            painter: _RevealPainter(
              snapshot: widget.snapshot,
              pixelRatio: widget.pixelRatio,
              origin: widget.origin,
              radius: _radius.value,
              toDark: widget.toDark,
            ),
          );
        },
      ),
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _RevealPainter extends CustomPainter {
  _RevealPainter({
    required this.snapshot,
    required this.pixelRatio,
    required this.origin,
    required this.radius,
    required this.toDark,
  });

  final ui.Image snapshot;
  final double pixelRatio;
  final Offset origin;
  final double radius;
  final bool toDark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: origin, radius: radius));

    if (toDark) {
      canvas.clipPath(circlePath);
    } else {
      final fullPath = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      final invertedPath = Path.combine(
        PathOperation.difference,
        fullPath,
        circlePath,
      );
      canvas.clipPath(invertedPath);
    }

    final src = Rect.fromLTWH(
      0,
      0,
      snapshot.width.toDouble(),
      snapshot.height.toDouble(),
    );
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(snapshot, src, dst, Paint());

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RevealPainter old) {
    return old.radius != radius;
  }
}
