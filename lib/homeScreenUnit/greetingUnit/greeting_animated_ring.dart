import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class GreetingAnimatedRing extends StatelessWidget {
  final AnimationController controller;
  final List<Color> ringColors;
  final List<double> ringStops;
  final Widget child;

  const GreetingAnimatedRing({
    super.key,
    required this.controller,
    required this.ringColors,
    required this.ringStops,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * 2 * pi;
        return Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgRadius,
            gradient: SweepGradient(
              colors: ringColors,
              stops: ringStops,
              transform: GradientRotation(angle),
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
