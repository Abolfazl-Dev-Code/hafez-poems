import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/theme/animated_app_icons.dart';
import 'package:hafez_poems/theme/app_icons.dart';

/// Represents the four greeting periods used across the app.
///
/// Kept as a standalone, dependency-free utility (no BuildContext, no
/// GetX) so it can be reused later by a background notification
/// scheduler (e.g. to decide when to fire a "صبح بخیر" push) without
/// dragging in widget code.
enum GreetingPeriod { morning, noon, evening, night }

class GreetingScheduleUtils {
  GreetingScheduleUtils._();

  /// Hour boundaries: [morning start, noon start, evening start, night start]
  static const List<int> boundaryHours = [6, 12, 17, 21];

  static GreetingPeriod periodForHour(int hour) {
    if (hour >= 6 && hour < 12) return GreetingPeriod.morning;
    if (hour >= 12 && hour < 17) return GreetingPeriod.noon;
    if (hour >= 17 && hour < 21) return GreetingPeriod.evening;
    return GreetingPeriod.night;
  }

  /// Returns the next moment (today or tomorrow) at which the greeting
  /// period changes. Shared by the UI ticker and — later — by whatever
  /// schedules the greeting-based push notifications, so both stay in
  /// sync with a single source of truth.
  static DateTime nextBoundary(DateTime now) {
    final points = boundaryHours
        .map((h) => DateTime(now.year, now.month, now.day, h))
        .toList();

    for (final point in points) {
      if (point.isAfter(now)) return point;
    }

    return DateTime(now.year, now.month, now.day + 1, boundaryHours.first);
  }
}

/// Minimal, dependency-free Gregorian → Jalali (Shamsi) date converter.
/// Avoids pulling in a new pub package just for this label.
class PersianDateUtils {
  PersianDateUtils._();

  static const List<String> _monthNames = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند', // ignore: prefer_const_literals_to_create_immutables
  ];

  // Index 1..7 matches DateTime.weekday (1 = Monday ... 7 = Sunday).
  static const List<String> _weekdayNames = [
    '',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
    'شنبه',
    'یکشنبه',
  ];

  static List<int> _toJalali(int gy, int gm, int gd) {
    const gDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    final gy2 = (gm > 2) ? (gy + 1) : gy;
    var days =
        355666 +
        (365 * gy) +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) +
        gd +
        gDaysInMonth.take(gm - 1).fold<int>(0, (a, b) => a + b);

    var jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }

    final int jm;
    final int jd;
    if (days < 186) {
      jm = 1 + (days ~/ 31);
      jd = 1 + (days % 31);
    } else {
      jm = 7 + ((days - 186) ~/ 30);
      jd = 1 + ((days - 186) % 30);
    }
    return [jy, jm, jd];
  }

  /// e.g. "دوشنبه، ۵ مرداد"
  static String formatShort(DateTime date) {
    final jalali = _toJalali(date.year, date.month, date.day);
    final weekday = _weekdayNames[date.weekday];
    final month = _monthNames[jalali[1] - 1];
    return '$weekday، ${jalali[2]} $month';
  }
}

class GreetingCard extends StatefulWidget {
  const GreetingCard(
    ThemeData theme, {
    super.key,
    this.iconScale = 1.5,
    this.iconSpeed = 1.2,
    // Optional: pass the user's current consecutive-reading streak once
    // it's available from the ReadStatus repository. Left nullable and
    // widget-supplied (rather than assumed on ProfileController) so this
    // compiles regardless of how/when that data gets wired up.
    this.streakDays,
  });

  final double iconScale;
  final double iconSpeed;
  final int? streakDays;

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  Timer? _timer;

  void _scheduleUpdate() {
    _timer?.cancel();

    final next = GreetingScheduleUtils.nextBoundary(DateTime.now());

    _timer = Timer(next.difference(DateTime.now()), () {
      if (!mounted) return;

      setState(() {});

      _scheduleUpdate();
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  GreetingPeriod get _period =>
      GreetingScheduleUtils.periodForHour(DateTime.now().hour);

  String _greetingText({String name = ''}) {
    final base = switch (_period) {
      GreetingPeriod.morning => 'صبح بخیر',
      GreetingPeriod.noon => 'ظهر بخیر',
      GreetingPeriod.evening => 'عصر بخیر',
      GreetingPeriod.night => 'شب بخیر',
    };

    return name.trim().isEmpty ? base : '$base ${name.trim()}';
  }

  String get _greetingSubtitle {
    return switch (_period) {
      GreetingPeriod.morning => 'روزت رو با یه بیت حافظ شروع کن ☀️',
      GreetingPeriod.noon => 'یه لحظه استراحت با حافظ 🍃',
      GreetingPeriod.evening => 'عصرانه‌ات رو با شعر همراه کن 🌿',
      GreetingPeriod.night => 'شبت رو با حافظ آروم کن 🌙',
    };
  }

  String get _greetingAsset {
    return switch (_period) {
      GreetingPeriod.morning => AppIcons.morning,
      GreetingPeriod.noon => AppIcons.noon,
      GreetingPeriod.evening => AppIcons.evening,
      GreetingPeriod.night => AppIcons.night,
    };
  }

  List<Color> _greetingGradientForTheme(bool isLight) {
    if (isLight) {
      return switch (_period) {
        GreetingPeriod.morning => [
          const Color(0xFFFFF8EE),
          const Color(0xFFFFEDD5),
        ],
        GreetingPeriod.noon => [
          const Color(0xFFEFFAF0),
          const Color(0xFFD4F0D8),
        ],
        GreetingPeriod.evening => [
          const Color(0xFFFFF0F3),
          const Color(0xFFFFD6E0),
        ],
        GreetingPeriod.night => [
          const Color(0xFFF0ECFC),
          const Color(0xFFE0D5F5),
        ],
      };
    } else {
      return switch (_period) {
        GreetingPeriod.morning => [
          const Color(0xFF2A1F10),
          const Color(0xFF1E1508),
        ],
        GreetingPeriod.noon => [
          const Color(0xFF0F1F12),
          const Color(0xFF0A1A0C),
        ],
        GreetingPeriod.evening => [
          const Color(0xFF221018),
          const Color(0xFF180A10),
        ],
        GreetingPeriod.night => [
          const Color(0xFF14102A),
          const Color(0xFF0D0A1E),
        ],
      };
    }
  }

  Color _greetingIconColor(bool isLight) {
    if (isLight) {
      return switch (_period) {
        GreetingPeriod.morning => const Color(0xFFE67E22),
        GreetingPeriod.noon => const Color(0xFF27AE60),
        GreetingPeriod.evening => const Color(0xFFE91E8C),
        GreetingPeriod.night => const Color(0xFF7C4DFF),
      };
    } else {
      return switch (_period) {
        GreetingPeriod.morning => const Color(0xFFFFB74D),
        GreetingPeriod.noon => const Color(0xFF81C784),
        GreetingPeriod.evening => const Color(0xFFF48FB1),
        GreetingPeriod.night => const Color(0xFFB39DDB),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final gradColors = _greetingGradientForTheme(isLight);
    final iconColor = _greetingIconColor(isLight);
    final dateLabel = PersianDateUtils.formatShort(DateTime.now());

    final ProfileController profileController = Get.find<ProfileController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: AnimatedAppIcon(
                  key: ValueKey(_greetingAsset),
                  asset: _greetingAsset,
                  size: 22,
                  scale: widget.iconScale,
                  color: iconColor,
                  repeat: true,
                  autoplay: true,
                  speed: widget.iconSpeed,
                  animateOnTap: false,
                  animateOnSelected: false,
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
                      Expanded(
                        child: Obx(() {
                          final userName = profileController.userName.value;
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.centerRight,
                                children: [...previousChildren, ?currentChild],
                              );
                            },
                            child: Text(
                              _greetingText(name: userName),
                              key: ValueKey('${_period}_$userName'),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontFamily: 'vazir',
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      if (widget.streakDays != null && widget.streakDays! > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '🔥 ${widget.streakDays} روز'.toPersianNumbers(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'vazir',
                              fontWeight: FontWeight.w600,
                              color: iconColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _greetingSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'vazir',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel.toPersianNumbers(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFamily: 'vazir',
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
