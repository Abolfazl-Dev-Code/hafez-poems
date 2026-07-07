import 'dart:math';
import 'package:flutter/material.dart';

class NoiseParticlesBackground extends StatefulWidget {
  final Color color;
  final int particleCount;
  final double minRadius;
  final double maxRadius;
  final double minOpacity;
  final double maxOpacity;
  final Duration cycleDuration;
  final Brightness brightness;

  const NoiseParticlesBackground({
    super.key,
    required this.color,
    this.particleCount = 45,
    this.minRadius = 1.2,
    this.maxRadius = 2.2,
    this.minOpacity = 0.05,
    this.maxOpacity = 0.11,
    this.cycleDuration = const Duration(seconds: 24),
    this.brightness = Brightness.dark,
  });

  @override
  State<NoiseParticlesBackground> createState() =>
      _NoiseParticlesBackgroundState();
}

class _NoiseParticlesBackgroundState extends State<NoiseParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    )..repeat();

    final random = Random(7);
    final cols = sqrt(widget.particleCount.toDouble()).ceil();
    final rows = (widget.particleCount / cols).ceil();

    _particles = List.generate(widget.particleCount, (i) {
      final col = i % cols;
      final row = i ~/ cols;
      return _Particle(
        baseX: (col + 0.15 + random.nextDouble() * 0.7) / cols,
        baseY: (row + 0.15 + random.nextDouble() * 0.7) / rows,
        radius:
            widget.minRadius +
            random.nextDouble() * (widget.maxRadius - widget.minRadius),
        opacity:
            widget.minOpacity +
            random.nextDouble() * (widget.maxOpacity - widget.minOpacity),
        ampX: 0.012 + random.nextDouble() * 0.018,
        ampY: 0.012 + random.nextDouble() * 0.018,
        freqX: 1 + random.nextInt(3),
        freqY: 1 + random.nextInt(3),
        phase: random.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = widget.brightness == Brightness.light;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _NoisePainter(
              particles: _particles,
              t: _controller.value,
              color: widget.color,
              opacityMultiplier: isLight ? 2.2 : 1.0,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double baseX;
  final double baseY;
  final double radius;
  final double opacity;
  final double ampX;
  final double ampY;
  final int freqX;
  final int freqY;
  final double phase;

  _Particle({
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.opacity,
    required this.ampX,
    required this.ampY,
    required this.freqX,
    required this.freqY,
    required this.phase,
  });
}

class _NoisePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  final Color color;
  final double opacityMultiplier;

  _NoisePainter({
    required this.particles,
    required this.t,
    required this.color,
    this.opacityMultiplier = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = sin(2 * pi * (t * p.freqX) + p.phase) * p.ampX;
      final dy = cos(2 * pi * (t * p.freqY) + p.phase) * p.ampY;

      final x = (p.baseX + dx) * size.width;
      final y = (p.baseY + dy) * size.height;

      final paint = Paint()
        ..color = color.withValues(
          alpha: (p.opacity * opacityMultiplier).clamp(0.0, 1.0),
        );
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => true;
}
