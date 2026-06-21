import 'package:flutter/material.dart';

class BottomNavBarAnimation extends CustomPainter {
  final double loc;
  final double s;
  final Color color;

  BottomNavBarAnimation({
    required this.loc,
    required this.s,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double centerX = (loc + s / 2) * size.width;

    const double r = 32;
    const double p = 0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - r - p, 0)
      ..bezierTo(centerX - r - (p / 2), 0, centerX - r, 0, centerX - r, p)
      ..arcToPoint(
        Offset(centerX + r, p),
        radius: const Radius.circular(r),
        clockwise: false,
      )
      ..bezierTo(centerX + r, 0, centerX + r + (p / 2), 0, centerX + r + p, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomNavBarAnimation oldDelegate) => true;
}

extension PathExt on Path {
  void bezierTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    cubicTo(x1, y1, x2, y2, x3, y3);
  }
}
