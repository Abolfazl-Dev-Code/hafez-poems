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
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final baseSize = 24.0 * textScale.clamp(1.0, 1.6);

    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final t = _pulseCtrl.value;
        final ringScale = 1.0 + (t * 0.45);
        final ringOpacity = (1.0 - t) * 0.35;
        final coreScale = 0.85 + (t * 0.15);

        return SizedBox(
          width: baseSize * 1.6,
          height: baseSize * 1.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: ringScale,
                child: Container(
                  width: baseSize,
                  height: baseSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: ringOpacity),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: coreScale,
                child: Container(
                  width: baseSize * 0.62,
                  height: baseSize * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.color,
                        widget.color.withValues(alpha: 0.65),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.35),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
