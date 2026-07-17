import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/theme/animated_app_icons.dart';
import 'package:hafez_poems/theme/app_icons.dart';

class GreetingCard extends StatefulWidget {
  const GreetingCard(
    ThemeData theme, {
    super.key,
    this.iconScale = 1.5,
    this.iconSpeed = 1.5,
  });

  final double iconScale;
  final double iconSpeed;

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  Timer? _timer;

  DateTime _nextGreetingTime() {
    final now = DateTime.now();

    final points = [
      DateTime(now.year, now.month, now.day, 6),
      DateTime(now.year, now.month, now.day, 12),
      DateTime(now.year, now.month, now.day, 17),
      DateTime(now.year, now.month, now.day, 21),
    ];

    for (final point in points) {
      if (point.isAfter(now)) return point;
    }

    return DateTime(now.year, now.month, now.day + 1, 6);
  }

  void _scheduleUpdate() {
    _timer?.cancel();

    final next = _nextGreetingTime();

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

  String _greetingText({String name = ''}) {
    final hour = DateTime.now().hour;
    String base;

    if (hour >= 6 && hour < 12) {
      base = 'صبح بخیر';
    } else if (hour >= 12 && hour < 17) {
      base = 'ظهر بخیر';
    } else if (hour >= 17 && hour < 21) {
      base = 'عصر بخیر';
    } else {
      base = 'شب بخیر';
    }

    return name.trim().isEmpty ? base : '$base ${name.trim()}';
  }

  String get _greetingSubtitle {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      return 'روزت رو با یه بیت حافظ شروع کن ☀️';
    }
    if (hour >= 12 && hour < 17) {
      return 'یه لحظه استراحت با حافظ 🍃';
    }
    if (hour >= 17 && hour < 21) {
      return 'عصرانه‌ات رو با شعر همراه کن 🌿';
    }

    return 'شبت رو با حافظ آروم کن 🌙';
  }

  String get _greetingAsset {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) return AppIcons.morning;
    if (hour >= 12 && hour < 17) return AppIcons.noon;
    if (hour >= 17 && hour < 21) return AppIcons.evening;

    return AppIcons.night;
  }

  List<Color> _greetingGradientForTheme(bool isLight) {
    final hour = DateTime.now().hour;

    if (isLight) {
      if (hour >= 6 && hour < 12) {
        return [const Color(0xFFFFF8EE), const Color(0xFFFFEDD5)];
      }
      if (hour >= 12 && hour < 17) {
        return [const Color(0xFFEFFAF0), const Color(0xFFD4F0D8)];
      }
      if (hour >= 17 && hour < 21) {
        return [const Color(0xFFFFF0F3), const Color(0xFFFFD6E0)];
      }
      return [const Color(0xFFF0ECFC), const Color(0xFFE0D5F5)];
    } else {
      if (hour >= 6 && hour < 12) {
        return [const Color(0xFF2A1F10), const Color(0xFF1E1508)];
      }
      if (hour >= 12 && hour < 17) {
        return [const Color(0xFF0F1F12), const Color(0xFF0A1A0C)];
      }
      if (hour >= 17 && hour < 21) {
        return [const Color(0xFF221018), const Color(0xFF180A10)];
      }
      return [const Color(0xFF14102A), const Color(0xFF0D0A1E)];
    }
  }

  Color _greetingIconColor(bool isLight) {
    final hour = DateTime.now().hour;

    if (isLight) {
      if (hour >= 6 && hour < 12) return const Color(0xFFE67E22);
      if (hour >= 12 && hour < 17) return const Color(0xFF27AE60);
      if (hour >= 17 && hour < 21) return const Color(0xFFE91E8C);
      return const Color(0xFF7C4DFF);
    } else {
      if (hour >= 6 && hour < 12) return const Color(0xFFFFB74D);
      if (hour >= 12 && hour < 17) return const Color(0xFF81C784);
      if (hour >= 17 && hour < 21) return const Color(0xFFF48FB1);
      return const Color(0xFFB39DDB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final gradColors = _greetingGradientForTheme(isLight);
    final iconColor = _greetingIconColor(isLight);

    final ProfileController profileController = Get.find<ProfileController>();

    return Obx(() {
      final userName = profileController.userName.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greetingText(name: userName),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontFamily: 'vazir',
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.85,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _greetingSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'vazir',
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
