import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

class ProgressStatBar extends StatelessWidget {
  final String label;
  final double progress; // 0.0 تا 1.0 (بیشترش هم باشه خودش clamp می‌شه)
  final List<Color> gradientColors; // [رنگ پررنگ, Colors.white]
  final IconData icon;

  const ProgressStatBar({
    super.key,
    required this.label,
    required this.progress,
    required this.gradientColors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clamped = progress.clamp(0.0, 1.0);
    final percentText =
        '٪${(clamped * 100).round().toString().toPersianNumbers()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: gradientColors.first),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              percentText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                height: 10,
                width: double.infinity,
                color: gradientColors.first.withValues(alpha: 0.12),
              ),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: clamped,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProgressOverviewCard extends StatelessWidget {
  final double likedProgress;
  final double savedProgress;
  final double readProgress;

  const ProgressOverviewCard({
    super.key,
    required this.likedProgress,
    required this.savedProgress,
    required this.readProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: isLight
          ? Colors.white.withValues(alpha: 0.94)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ProgressStatBar(
              label: 'علاقه‌مندی‌‌شده از کل غزل‌ها',
              icon: Icons.favorite_rounded,
              progress: likedProgress,
              gradientColors: const [Colors.redAccent, Colors.white],
            ),
            const SizedBox(height: 20),
            ProgressStatBar(
              label: 'ذخیره‌شده از کل غزل‌ها',
              icon: Icons.bookmark_rounded,
              progress: savedProgress,
              gradientColors: const [Color(0xFF2E7D32), Colors.white],
            ),
            const SizedBox(height: 20),
            ProgressStatBar(
              label: 'خوانده‌شده از کل دیوان',
              icon: Icons.menu_book_rounded,
              progress: readProgress,
              gradientColors: const [Color(0xFF1565C0), Colors.white],
            ),
          ],
        ),
      ),
    );
  }
}
