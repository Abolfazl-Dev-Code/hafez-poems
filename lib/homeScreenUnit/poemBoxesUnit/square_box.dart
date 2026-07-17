import 'package:flutter/material.dart';

class SquareActionBox extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const SquareActionBox({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: theme.brightness == Brightness.dark ? 6 : 3,
            shadowColor: theme.shadowColor.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.3 : 0.10,
            ),
            surfaceTintColor: Colors.transparent,
            color: theme.brightness == Brightness.light
                ? colorScheme.outlineVariant.withValues(alpha: 0.2)
                : colorScheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.25 : 0.10,
                ),
              ),
            ),
            child: SizedBox(width: 59, height: 59, child: Center(child: icon)),
          ),

          const SizedBox(height: 4),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
