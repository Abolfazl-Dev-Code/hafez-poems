import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

export 'streak_motivation_card.dart';

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
        borderRadius: AppRadius.xlRadius,
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
