import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool enabled;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: titleColor ?? colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
        trailing: trailing,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
