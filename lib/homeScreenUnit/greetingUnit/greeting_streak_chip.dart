import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

class GreetingStreakChip extends StatelessWidget {
  final int streakDays;
  final Color iconColor;
  final TextStyle? textStyle;

  const GreetingStreakChip({
    super.key,
    required this.streakDays,
    required this.iconColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.14),
        borderRadius: AppRadius.xlRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LucideAnimatedIcon(icon: flame, size: 14, color: iconColor),
          const SizedBox(width: 3),
          Text(
            '$streakDays روز'.toPersianNumbers(),
            style: textStyle?.copyWith(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
