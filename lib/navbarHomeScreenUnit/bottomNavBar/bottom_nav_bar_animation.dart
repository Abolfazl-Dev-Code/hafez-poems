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

    const double notchRadius = 32.0; // دقیقاً مثل کد اصلی - عمق تغییر نمی‌کند
    const double cornerRadius = 6.0; // گردی گوشه‌های چپ و راست نوار
    const double filletRadius =
        0.0; // گردی اتصال به نیم‌دایره (نرم و بدون افزایش عمق)

    final path = Path()
      // شروع از پایین چپ
      ..moveTo(0, size.height)
      ..lineTo(0, cornerRadius)
      // گوشه بالا-چپ نوار
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      // خط مستقیم تا قبل از اتصال گرد به نیم‌دایره
      ..lineTo(centerX - notchRadius - filletRadius, 0)
      // === اتصال نرم (گرد) به سمت چپ نیم‌دایره ===
      ..quadraticBezierTo(
        centerX - notchRadius,
        0,
        centerX - notchRadius,
        filletRadius,
      )
      // === نیم‌دایره اصلی (عمق دقیقاً مثل کد اولیه) ===
      ..arcToPoint(
        Offset(centerX + notchRadius, filletRadius),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )
      // === اتصال نرم (گرد) به سمت راست ===
      ..quadraticBezierTo(
        centerX + notchRadius,
        0,
        centerX + notchRadius + filletRadius,
        0,
      )
      // خط مستقیم تا قبل از گوشه راست نوار
      ..lineTo(size.width - cornerRadius, 0)
      // گوشه بالا-راست نوار
      ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
      // پایین نوار
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
