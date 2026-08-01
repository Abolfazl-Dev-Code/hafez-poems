import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafez_poems/models/onboarding_particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress * 2 * pi * p.speed + p.phase;

      _paint.color = color.withValues(alpha: p.opacity);

      canvas.drawCircle(
        Offset(
          p.x * size.width + cos(t * .6) * 10,
          p.y * size.height + sin(t) * 18,
        ),
        p.radius,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        !identical(oldDelegate.particles, particles);
  }
}
