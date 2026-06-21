import 'package:flutter/material.dart';

class PoemListEmpty extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;

  const PoemListEmpty({super.key, required this.text, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),

          const SizedBox(height: 12),

          Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }
}
