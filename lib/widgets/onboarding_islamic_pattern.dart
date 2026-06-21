import 'dart:math';
import 'package:flutter/material.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double progress;

  IslamicPatternPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const step = 80.0;

    final shift = sin(progress * 2 * pi) * 4;

    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        _drawStar(canvas, paint, Offset(x + shift, y + shift), 28);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double r) {
    const points = 8;

    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi) / points - pi / 2;

      final radius = i.isEven ? r : r * 0.45;

      final px = center.dx + radius * cos(angle);
      final py = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(IslamicPatternPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
