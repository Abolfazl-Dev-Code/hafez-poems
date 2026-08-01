import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';

const _kGold = BiographyColors.gold;

class SkylinePainter extends CustomPainter {
  const SkylinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = const Color(0xFF0A0E22)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _kGold.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.46)
      ..quadraticBezierTo(w * 0.06, h * 0.32, w * 0.09, h * 0.04)
      ..quadraticBezierTo(w * 0.11, h * -0.06, w * 0.13, h * 0.04)
      ..quadraticBezierTo(w * 0.15, h * 0.32, w * 0.21, h * 0.40)
      ..lineTo(w * 0.30, h * 0.40)
      ..quadraticBezierTo(w * 0.32, h * 0.10, w * 0.34, h * -0.06)
      ..quadraticBezierTo(w * 0.36, h * -0.16, w * 0.38, h * -0.06)
      ..quadraticBezierTo(w * 0.40, h * 0.10, w * 0.43, h * 0.40)
      ..lineTo(w * 0.58, h * 0.40)
      ..quadraticBezierTo(w * 0.62, h * 0.14, w * 0.70, h * 0.14)
      ..quadraticBezierTo(w * 0.78, h * 0.14, w * 0.82, h * 0.40)
      ..lineTo(w * 0.84, h * 0.40)
      ..quadraticBezierTo(w * 0.86, h * -0.02, w * 0.90, h * -0.08)
      ..quadraticBezierTo(w * 0.94, h * -0.14, w * 0.97, h * -0.08)
      ..quadraticBezierTo(w * 1.00, h * -0.02, w * 1.00, h * 0.40)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant SkylinePainter oldDelegate) => false;
}
