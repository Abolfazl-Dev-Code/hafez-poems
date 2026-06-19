import 'package:flutter/material.dart';

class ActiveVerseIndicator extends StatefulWidget {
  final Color color;

  const ActiveVerseIndicator({super.key, required this.color});

  @override
  State<ActiveVerseIndicator> createState() => _ActiveVerseIndicatorState();
}

class _ActiveVerseIndicatorState extends State<ActiveVerseIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        // مقیاس نرم بین 0.85 و 1.15 برای حس «نفس کشیدن»
        final scale = 0.75 + (_pulseCtrl.value * 0.30);
        // شفافیت نرم بین 0.55 و 1.0
        final opacity = 0.55 + (_pulseCtrl.value * 0.45);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Transform.flip(
                  flipX: true,
                  child: Icon(Icons.arrow_back, size: 15, color: widget.color),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
