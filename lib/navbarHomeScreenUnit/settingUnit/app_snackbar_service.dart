import 'package:flutter/material.dart';

class AppSnackBarService {
  static void _show({
    required BuildContext context,
    required String message,
    required Color color,
    required IconData icon,
    Color textColor = Colors.white,
    Duration duration = const Duration(milliseconds: 2400),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      padding: EdgeInsets.zero,
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: textColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                duration: duration,
                builder: (context, value, child) {
                  return SizedBox(
                    height: 4,
                    child: Stack(
                      children: [
                        Container(color: Colors.white.withValues(alpha: 0.22)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: value,
                            child: Container(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context: context,
      message: message,
      color: const Color(0xFFFFC107),
      icon: Icons.warning_amber_rounded,
      textColor: Colors.black,
      duration: duration ?? const Duration(milliseconds: 2400),
    );
  }

  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context: context,
      message: message,
      color: const Color(0xFF1FA855),
      icon: Icons.check_rounded,
      duration: duration ?? const Duration(milliseconds: 2400),
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context: context,
      message: message,
      color: const Color(0xFFD92D20),
      icon: Icons.close_rounded,
      duration: duration ?? const Duration(milliseconds: 2400),
    );
  }

  static void info(BuildContext context, String message, {Duration? duration}) {
    _show(
      context: context,
      message: message,
      color: const Color(0xFF2563EB),
      icon: Icons.info_outline,
      duration: duration ?? const Duration(milliseconds: 2400),
    );
  }
}
