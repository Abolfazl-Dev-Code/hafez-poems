import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class CarouselRefreshButton extends StatelessWidget {
  final bool isRefreshing;
  final bool isDark;
  final double turns;
  final VoidCallback onTap;

  const CarouselRefreshButton({
    super.key,
    required this.isRefreshing,
    required this.isDark,
    required this.turns,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.pillRadius,
        onTap: isRefreshing ? null : onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isRefreshing ? 0.55 : 1.0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppRadius.pillRadius,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.28 : 0.22,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedRotation(
              turns: turns,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              child: Icon(Icons.refresh, size: 22, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
