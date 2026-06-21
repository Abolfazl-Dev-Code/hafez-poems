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

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress * 2 * pi * p.speed + p.phase;

      final dx = cos(t * 0.6) * 10;
      final dy = sin(t) * 18;

      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        Paint()..color = color.withValues(alpha: p.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
