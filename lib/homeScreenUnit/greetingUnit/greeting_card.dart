import 'package:hafez_poems/theme/text_style.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_schedule.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_style.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/persian_date_utils.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_streak_chip.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_animated_ring.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/theme/animated_app_icons.dart';

class GreetingCard extends StatefulWidget {
  const GreetingCard(
    ThemeData theme, {
    super.key,
    this.iconScale = 1.5,
    this.iconSpeed = 1.2,
    this.streakDays,
  });

  final double iconScale;
  final double iconSpeed;
  final int? streakDays;

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Timer? _timer;
  late final AnimationController _borderController;

  void _scheduleUpdate() {
    _timer?.cancel();
    final next = GreetingScheduleUtils.nextBoundary(DateTime.now());
    final delay = next.difference(DateTime.now());
    _timer = Timer(delay.isNegative ? Duration.zero : delay, () {
      if (!mounted) return;
      setState(() {});
      _scheduleUpdate();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!mounted) return;
      setState(() {});
      _scheduleUpdate();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleUpdate();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _borderController.dispose();
    super.dispose();
  }

  GreetingPeriod get _period =>
      GreetingScheduleUtils.periodForHour(DateTime.now().hour);

  String _greetingText({String name = ''}) {
    final base = GreetingNotificationContent.titleFor(_period);
    return name.trim().isEmpty ? base : '$base ${name.trim()}';
  }

  String get _greetingSubtitle => GreetingNotificationContent.bodyFor(_period);

  Color _vivid(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withSaturation(1.0).withLightness(0.55).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final gradColors = GreetingStyle.gradient(_period, isLight);
    final iconColor = GreetingStyle.iconColor(_period, isLight);
    final greetingAsset = GreetingStyle.asset(_period);
    final dateLabel = PersianDateUtils.formatShort(DateTime.now());

    final ProfileController? profileController =
        Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : null;

    final ringBase = _vivid(gradColors.first).withValues(alpha: 0.18);
    final ringColors = [
      ringBase,
      ringBase,
      _vivid(iconColor),
      Colors.white.withValues(alpha: 0.95),
      _vivid(gradColors.last),
      ringBase,
      ringBase,
    ];
    const ringStops = [0.0, 0.08, 0.15, 0.19, 0.23, 0.32, 1.0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GreetingAnimatedRing(
        controller: _borderController,
        ringColors: ringColors,
        ringStops: ringStops,
        child: ClipRRect(
          borderRadius: AppRadius.mdRadius,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradColors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
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
                      key: ValueKey(greetingAsset),
                      asset: greetingAsset,
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
                              final userName =
                                  profileController?.userName.value ?? '';
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                layoutBuilder:
                                    (currentChild, previousChildren) {
                                      return Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          ...previousChildren,
                                          ?currentChild,
                                        ],
                                      );
                                    },
                                child: Text(
                                  _greetingText(name: userName),
                                  key: ValueKey('${_period}_$userName'),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.85),
                                  ),
                                ),
                              );
                            }),
                          ),
                          if (widget.streakDays != null &&
                              widget.streakDays! > 0)
                            GreetingStreakChip(
                              streakDays: widget.streakDays!,
                              iconColor: iconColor,
                              textStyle: theme.textTheme.labelSmall,
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _greetingSubtitle.toPersianNumbers(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateLabel.toPersianNumbers(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
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
        ),
      ),
    );
  }
}
