import 'dart:math';
import 'package:flutter/material.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double progress;

  IslamicPatternPainter({required this.color, required this.progress});

  static const double _step = 80;
  static const double _radius = 28;
  static const int _points = 8;

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Path? _cachedStarPath;

  Path _buildStarPath() {
    final path = Path();

    for (int i = 0; i < _points * 2; i++) {
      final angle = (i * pi) / _points - pi / 2;
      final radius = i.isEven ? _radius : _radius * .45;

      final x = radius * cos(angle);
      final y = radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = color;

    final star = _cachedStarPath ??= _buildStarPath();

    final shift = sin(progress * 2 * pi) * 4;

    for (double x = -_step; x < size.width + _step; x += _step) {
      for (double y = -_step; y < size.height + _step; y += _step) {
        canvas.save();

        canvas.translate(x + shift, y + shift);

        canvas.drawPath(star, _paint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
