import 'package:flutter/material.dart';
import 'package:hafez_poems/widgets/persian_numbers.dart';

class StatCard extends StatefulWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: isLight ? 0.18 : 0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: isLight
              ? Colors.white.withValues(alpha: 0.92)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            highlightColor: Colors.transparent,
            onHighlightChanged: (isHighlighted) {
              setState(() => _scale = isHighlighted ? 0.96 : 1.0);
            },
            child: Column(
              children: [
                Container(height: 4, color: widget.color),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withValues(alpha: 0.22),
                              widget.color.withValues(alpha: 0.10),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(widget.icon, color: widget.color, size: 22),
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: widget.value),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, animatedValue, _) {
                          return Text(
                            animatedValue.toString().toPersianNumbers(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
