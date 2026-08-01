import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class QuoteCard extends StatelessWidget {
  final String title;
  final String quote;

  const QuoteCard({super.key, required this.title, required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: AppRadius.xlRadius,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isLight
                ? const [Color(0xFFFFF8E8), Color(0xFFFFF3D6)]
                : [
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
                    colorScheme.surfaceContainer.withValues(alpha: 0.75),
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote_rounded, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quote,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.9),
            ),
          ],
        ),
      ),
    );
  }
}
