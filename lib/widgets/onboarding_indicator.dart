import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int length;
  final int current;
  final Color color;

  const OnboardingIndicator({
    super.key,
    required this.length,
    required this.current,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == current ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == current ? color : color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
