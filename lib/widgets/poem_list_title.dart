import 'package:flutter/material.dart';

class PoemListTitle extends StatelessWidget {
  final String title;
  final bool hasFullText;
  final VoidCallback onTap;

  const PoemListTitle({
    super.key,
    required this.title,
    required this.hasFullText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.book_rounded, color: colorScheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: hasFullText
          ? null
          : Text(
              'در حال دریافت...',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
      trailing: Icon(
        Icons.chevron_left_rounded,
        color: colorScheme.onSurface.withValues(alpha: 0.45),
      ),
      onTap: onTap,
    );
  }
}
