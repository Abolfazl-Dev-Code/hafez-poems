import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_shadows.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;

  const SectionCard({
    super.key,
    required this.title,
    required this.children,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.8)),
        boxShadow: AppShadows.card(context),
      ),
      child: Material(
        color: Colors
            .transparent, // فقط میزبان ink splash میشه، رنگی اضافه نمی‌کنه
        borderRadius: AppRadius.lgRadius,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
