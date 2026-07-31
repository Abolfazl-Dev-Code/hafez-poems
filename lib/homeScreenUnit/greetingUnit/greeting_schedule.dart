enum GreetingPeriod { morning, noon, evening, night }

class GreetingScheduleUtils {
  GreetingScheduleUtils._();

  static GreetingPeriod periodForHour(int hour) {
    if (hour >= 5 && hour < 12) {
      return GreetingPeriod.morning;
    }
    if (hour >= 12 && hour < 17) {
      return GreetingPeriod.noon;
    }
    if (hour >= 17 && hour < 21) {
      return GreetingPeriod.evening;
    }
    return GreetingPeriod.night;
  }

  static DateTime nextBoundary(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);

    final boundaries = <DateTime>[
      today.add(const Duration(hours: 5)),
      today.add(const Duration(hours: 12)),
      today.add(const Duration(hours: 17)),
      today.add(const Duration(hours: 21)),
      today.add(const Duration(days: 1, hours: 5)),
    ];

    return boundaries.firstWhere((e) => e.isAfter(now));
  }
}

class GreetingNotificationContent {
  GreetingNotificationContent._();

  static String titleFor(GreetingPeriod period) {
    switch (period) {
      case GreetingPeriod.morning:
        return 'صبح بخیر';
      case GreetingPeriod.noon:
        return 'ظهر بخیر';
      case GreetingPeriod.evening:
        return 'عصر بخیر';
      case GreetingPeriod.night:
        return 'شب بخیر';
    }
  }

  static String bodyFor(GreetingPeriod period) {
    switch (period) {
      case GreetingPeriod.morning:
        return 'روزت رو با یه بیت حافظ شروع کن ☀️';
      case GreetingPeriod.noon:
        return 'یه لحظه استراحت با حافظ 🍃';
      case GreetingPeriod.evening:
        return 'عصرانه‌ات رو با شعر همراه کن 🌿';
      case GreetingPeriod.night:
        return 'شبت رو با حافظ آروم کن 🌙';
    }
  }

  static String titleForHour(int hour) {
    return titleFor(GreetingScheduleUtils.periodForHour(hour));
  }

  static String bodyForHour(int hour) {
    return bodyFor(GreetingScheduleUtils.periodForHour(hour));
  }
}
