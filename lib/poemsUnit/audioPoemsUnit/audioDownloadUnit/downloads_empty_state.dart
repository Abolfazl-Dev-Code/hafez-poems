import 'package:flutter/material.dart';

class DownloadsEmptyState extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;

  const DownloadsEmptyState({super.key, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.download_for_offline_outlined,
            size: 36,
            color: cs.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 10),
          Text(
            'هنوز فایلی برای این شعر دانلود نکرده‌اید',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'از قسمت «خوانندگان» می‌توانید صدا را دانلود کنید',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.35),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
