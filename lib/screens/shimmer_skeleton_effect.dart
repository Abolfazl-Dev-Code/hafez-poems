import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton(ThemeData theme, {super.key});

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerLine(
    ThemeData theme, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.15),
            ),
            gradient: LinearGradient(
              begin: Alignment(_controller.value - 1, 0),
              end: Alignment(_controller.value, 0),
              colors: [
                theme.colorScheme.onSurface.withValues(alpha: 0.04),
                theme.colorScheme.onSurface.withValues(alpha: 0.10),
                theme.colorScheme.onSurface.withValues(alpha: 0.04),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _shimmerLine(theme, width: 180, height: 12),
                const SizedBox(height: 10),
                _shimmerLine(theme, width: double.infinity, height: 10),
                const SizedBox(height: 8),
                _shimmerLine(theme, width: 220, height: 10),
                const SizedBox(height: 16),
                _shimmerLine(theme, width: 90, height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
