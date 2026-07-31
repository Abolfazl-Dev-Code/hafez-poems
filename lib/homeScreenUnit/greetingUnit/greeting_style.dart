import 'package:flutter/material.dart';
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
      return switch (period) {
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

  static Color iconColor(GreetingPeriod period, bool isLight) {
    if (isLight) {
      return switch (period) {
        GreetingPeriod.morning => const Color(0xFFE67E22),
        GreetingPeriod.noon => const Color(0xFF27AE60),
        GreetingPeriod.evening => const Color(0xFFE91E8C),
        GreetingPeriod.night => const Color(0xFF7C4DFF),
      };
    } else {
      return switch (period) {
        GreetingPeriod.morning => const Color(0xFFFFB74D),
        GreetingPeriod.noon => const Color(0xFF81C784),
        GreetingPeriod.evening => const Color(0xFFF48FB1),
        GreetingPeriod.night => const Color(0xFFB39DDB),
      };
    }
  }
}
