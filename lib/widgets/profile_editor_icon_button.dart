import 'package:flutter/material.dart';

class EditProfileCornerButton extends StatelessWidget {
  final bool showHint;
  final VoidCallback onTap;
  final VoidCallback onDismissHint;

  const EditProfileCornerButton({
    super.key,
    required this.showHint,
    required this.onTap,
    required this.onDismissHint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final button = Material(
      color: colorScheme.primary.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(Icons.edit_rounded, color: colorScheme.primary, size: 18),
        ),
      ),
    );

    if (!showHint) return button;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        button,
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'برای تغییر نام، عکس یا توضیحات اینجا بزن',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isLight ? Colors.white : colorScheme.onPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDismissHint,
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: isLight ? Colors.white : colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
