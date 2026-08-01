import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: AppRadius.xsRadius,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
