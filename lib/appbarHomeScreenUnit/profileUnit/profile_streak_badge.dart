import 'package:flutter/material.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLight ? Colors.white : colorScheme.surfaceContainerHighest,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            streak.toString().toPersianNumbers(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

void showStreakInfo(BuildContext context, int streak, int bestStreak) {
  final String message;
  if (streak <= 0) {
    message = 'هر روز که اپ رو باز کنی این عدد بالا می‌ره';
  } else if (streak >= bestStreak) {
    message =
        '${streak.toString().toPersianNumbers()} روز پشت‌سرهم وارد برنامه شدی! این بهترین رکوردته';
  } else {
    final remaining = bestStreak - streak;
    message =
        '${streak.toString().toPersianNumbers()} روز پشت‌سرهم اپ رو باز کرده‌ای، ${remaining.toString().toPersianNumbers()} روز تا شکستن رکوردت';
  }

  AppSnackBarService.info(message);
}

void showStreakGuide(BuildContext context) {
  AppSnackBarService.info(
    duration: const Duration(seconds: 7),
    '🔥 روز شمار یعنی چند روز پشت‌سرهم برنامه رو باز کرده‌ای. '
    'هر روز که وارد بشی یه روز بهش اضافه می‌شه. '
    'اگه یه روز رو جا بندازی، از صفر شروع می‌شه!',
  );
}

class StreakMotivationCard extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;

  const StreakMotivationCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;

    final isNewRecord = bestStreak > 0 && currentStreak >= bestStreak;
    final remaining = (bestStreak - currentStreak).clamp(0, bestStreak);

    final String message;
    if (isNewRecord) {
      message = 'این بهترین امتیازیه که تا حالا داشتی، همینطور ادامه بده.';
    } else {
      message =
          '${remaining.toString().toPersianNumbers()} روز تا شکستن رکوردت';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isNewRecord
              ? [const Color(0xFFFF6B35), const Color(0xFFFFA45B)]
              : isLight
              ? [Colors.white.withValues(alpha: 0.95), const Color(0xFFFFF3E0)]
              : [
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
                  colorScheme.surfaceContainer.withValues(alpha: 0.75),
                ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => showStreakGuide(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isNewRecord
                      ? Colors.white.withValues(alpha: 0.92)
                      : colorScheme.onSurfaceVariant,
                  strokeAlign: 1,
                  width: 2.5,
                ),
                shape: BoxShape.circle,

                color: isNewRecord
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFFF6B35).withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: isNewRecord ? Colors.white : const Color(0xFFFF6B35),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${currentStreak.toString().toPersianNumbers()} روز',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isNewRecord ? Colors.white : null,
                      ),
                    ),
                    if (bestStreak > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isNewRecord
                              ? Colors.white.withValues(alpha: 0.25)
                              : colorScheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'رکورد: ${bestStreak.toString().toPersianNumbers()}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isNewRecord
                                ? Colors.white
                                : colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isNewRecord
                        ? Colors.white.withValues(alpha: 0.92)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
