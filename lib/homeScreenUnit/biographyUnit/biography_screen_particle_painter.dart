import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/models/biography_models.dart';

const _kGold = BiographyColors.gold;

class ParticlePainterBiography extends CustomPainter {
  final List<Particle> particles;
  final double t;

  ParticlePainterBiography(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in particles) {
      final phase = (p.phase + t) % 1.0;

      final x = p.startX * size.width + p.drift * sin(phase * pi);
      final y = phase * size.height * 1.08 - size.height * 0.04;

      final opacity = phase < 0.1
          ? phase / 0.1
          : (phase > 0.88 ? (1 - phase) / 0.12 : 1.0);

      paint.color = _kGold.withValues(alpha: 0.55 * opacity.clamp(0, 1));

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainterBiography oldDelegate) {
    return oldDelegate.t != t;
  }
}
