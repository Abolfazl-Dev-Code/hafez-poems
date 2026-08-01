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

    const double notchRadius = 32.0;
    const double cornerRadius = 6.0;
    const double filletRadius = 0.0;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..lineTo(centerX - notchRadius - filletRadius, 0)
      ..quadraticBezierTo(
        centerX - notchRadius,
        0,
        centerX - notchRadius,
        filletRadius,
      )
      ..arcToPoint(
        Offset(centerX + notchRadius, filletRadius),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(
        centerX + notchRadius,
        0,
        centerX + notchRadius + filletRadius,
        0,
      )
      ..lineTo(size.width - cornerRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomNavBarAnimation oldDelegate) =>
      oldDelegate.loc != loc ||
      oldDelegate.s != s ||
      oldDelegate.color != color;
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
