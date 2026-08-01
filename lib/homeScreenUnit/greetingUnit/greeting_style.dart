import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_colors.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_schedule.dart';
import 'package:hafez_poems/theme/app_icons.dart';

class GreetingStyle {
  GreetingStyle._();

  static String asset(GreetingPeriod period) {
    return switch (period) {
      GreetingPeriod.morning => AppIcons.morning,
      GreetingPeriod.noon => AppIcons.noon,
      GreetingPeriod.evening => AppIcons.evening,
      GreetingPeriod.night => AppIcons.night,
    };
  }

  static List<Color> gradient(GreetingPeriod period, bool isLight) {
    if (isLight) {
      return switch (period) {
        GreetingPeriod.morning => [
          GreetingColors.morningLightGradientStart,
          GreetingColors.morningLightGradientEnd,
        ],
        GreetingPeriod.noon => [
          GreetingColors.noonLightGradientStart,
          GreetingColors.noonLightGradientEnd,
        ],
        GreetingPeriod.evening => [
          GreetingColors.eveningLightGradientStart,
          GreetingColors.eveningLightGradientEnd,
        ],
        GreetingPeriod.night => [
          GreetingColors.nightLightGradientStart,
          GreetingColors.nightLightGradientEnd,
        ],
      };
    } else {
      return switch (period) {
        GreetingPeriod.morning => [
          GreetingColors.morningDarkGradientStart,
          GreetingColors.morningDarkGradientEnd,
        ],
        GreetingPeriod.noon => [
          GreetingColors.noonDarkGradientStart,
          GreetingColors.noonDarkGradientEnd,
        ],
        GreetingPeriod.evening => [
          GreetingColors.eveningDarkGradientStart,
          GreetingColors.eveningDarkGradientEnd,
        ],
        GreetingPeriod.night => [
          GreetingColors.nightDarkGradientStart,
          GreetingColors.nightDarkGradientEnd,
        ],
      };
    }
  }

  static Color iconColor(GreetingPeriod period, bool isLight) {
    if (isLight) {
      return switch (period) {
        GreetingPeriod.morning => GreetingColors.morningLightIcon,
        GreetingPeriod.noon => GreetingColors.noonLightIcon,
        GreetingPeriod.evening => GreetingColors.eveningLightIcon,
        GreetingPeriod.night => GreetingColors.nightLightIcon,
      };
    } else {
      return switch (period) {
        GreetingPeriod.morning => GreetingColors.morningDarkIcon,
        GreetingPeriod.noon => GreetingColors.noonDarkIcon,
        GreetingPeriod.evening => GreetingColors.eveningDarkIcon,
        GreetingPeriod.night => GreetingColors.nightDarkIcon,
      };
    }
  }
}
