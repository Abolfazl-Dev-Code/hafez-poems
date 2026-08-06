import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

class StreakMotivationCard extends StatefulWidget {
  final int currentStreak;
  final int bestStreak;

  const StreakMotivationCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  State<StreakMotivationCard> createState() => _StreakMotivationCardState();
}

class _StreakMotivationCardState extends State<StreakMotivationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final colorScheme = theme.colorScheme;

    final isNewRecord =
        widget.bestStreak > 0 && widget.currentStreak >= widget.bestStreak;
    final remaining = (widget.bestStreak - widget.currentStreak).clamp(
      0,
      widget.bestStreak,
    );

    final String message;
    if (isNewRecord) {
      message = 'این بهترین امتیازیه که تا حالا داشتی، همینطور ادامه بده.';
    } else {
      message =
          '${remaining.toString().toPersianNumbers()} روز تا شکستن رکوردت';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlRadius,
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isNewRecord
                        ? Colors.white.withValues(alpha: 0.92)
                        : colorScheme.onSurfaceVariant,
                    strokeAlign: 0.5,
                    width: 1,
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${widget.currentStreak.toString().toPersianNumbers()} روز',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isNewRecord ? Colors.white : null,
                          ),
                        ),
                        if (widget.bestStreak > 0) ...[
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
                              borderRadius: AppRadius.smRadius,
                            ),
                            child: Text(
                              'رکورد: ${widget.bestStreak.toString().toPersianNumbers()}',
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
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: AppRadius.smRadius,
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isExpanded ? 'نمایش کمتر' : 'نمایش بیشتر',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isNewRecord
                                  ? Colors.white
                                  : colorScheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: isNewRecord
                                  ? Colors.white
                                  : colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: Text(
                      // textAlign: TextAlign.right,
                      'روزشمار نشان میده چند روز پشت‌سرهم برنامه را باز کردی.\n'
                      'هر روزی که وارد برنامه بشی، یک روز به این عدد اضافه میشه.\n'
                      'اگر حتی یک روز وارد برنامه نشی، شمارنده از صفر شروع میکنه.\n'
                      'بیشترین روزهایی که وارد برنامه بشی. به عنوان رکوردت ثبت میشه.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.7,
                        fontSize: 15,
                        color: isNewRecord
                            ? Colors.white.withValues(alpha: 1)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
