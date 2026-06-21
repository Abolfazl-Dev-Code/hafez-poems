import 'dart:typed_data';
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

    // ۱) عکس از وضعیتِ فعلی (تمِ قدیمی) قبل از هر تغییری
    final ui.Image oldImage = await boundary.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData = await oldImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      onSwitch();
      return;
    }
    final Uint8List oldImageBytes = byteData.buffer.asUint8List();

    onSwitch();

    final maxRadius = _maxRadiusFromOrigin(origin, size);

    _entry = OverlayEntry(
      builder: (_) => _CircleRevealOverlay(
        oldImageBytes: oldImageBytes,
        origin: origin,
        maxRadius: maxRadius,
        toDark: toDark,
        onComplete: () {
          _entry?.remove();
          _entry = null;
        },
      ),
    );

    overlay.insert(_entry!);
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
    required this.oldImageBytes,
    required this.origin,
    required this.maxRadius,
    required this.toDark,
    required this.onComplete,
  });

  final Uint8List oldImageBytes;
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
        animation: _ctrl,
        builder: (context, _) {
          final clipper = widget.toDark
              ? _CircleClipper(center: widget.origin, radius: _radius.value)
              : _InverseCircleClipper(
                  center: widget.origin,
                  radius: _radius.value,
                );

          return ClipPath(
            clipper: clipper,
            child: Image.memory(
              widget.oldImageBytes,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        },
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  _CircleClipper({required this.center, required this.radius});

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _CircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}

class _InverseCircleClipper extends CustomClipper<Path> {
  _InverseCircleClipper({required this.center, required this.radius});

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    final fullRect = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final circle = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    return Path.combine(PathOperation.difference, fullRect, circle);
  }

  @override
  bool shouldReclip(covariant _InverseCircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}
