import 'package:flutter/material.dart';

class PoemListTitle extends StatelessWidget {
  final String title;
  final bool hasFullText;
  final VoidCallback onTap;
  final bool isRead;

  const PoemListTitle({
    super.key,
    required this.title,
    required this.hasFullText,
    required this.onTap,
    this.isRead = false,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRead) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 11,
                    color: colorScheme.primary.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'خوانده شده',
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.primary.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
          ],
          Icon(
            Icons.chevron_left_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
