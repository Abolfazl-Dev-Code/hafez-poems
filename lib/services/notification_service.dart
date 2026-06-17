import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  late tz.Location _local;

  static const int dailyReminderId = 1001;
  static const String channelId = 'daily_hafez_reminder';
  static const String channelName = 'یادآوری روزانه حافظ';
  static const String channelDescription =
      'اعلان یادآوری روزانه برای خواندن غزل حافظ';

  Future<void> init() async {
    tz.initializeTimeZones();
    _local = tz.getLocation('Asia/Tehran');
    tz.setLocalLocation(_local);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings: initSettings);
  }

  Future<bool> requestNotificationPermission() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl == null) return true;
    final granted = await androidImpl.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<bool> requestExactAlarmPermission() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl == null) return true;
    final granted = await androidImpl.requestExactAlarmsPermission();
    return granted ?? false;
  }

  Future<bool> requestReminderPermissions() async {
    final notifGranted = await requestNotificationPermission();
    if (!notifGranted) return false;
    return await requestExactAlarmPermission();
  }

  Future<void> scheduleDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notif_hour') ?? 13;
    final minute = prefs.getInt('notif_minute') ?? 0;
    await scheduleDailyReminderAt(hour: hour, minute: minute);
  }

  Future<void> scheduleDailyReminderAt({
    required int hour,
    required int minute,
  }) async {
    await cancelDailyReminder();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    final now = tz.TZDateTime.now(_local);
    var scheduled = tz.TZDateTime(
      _local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: dailyReminderId,
      title: '\u202Bحافظ\u202C',
      body: '\u202Bیه لیوان چایی و یه غزل حافظ\u202C',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(id: dailyReminderId);
  }

  Future<bool> isDailyReminderScheduled() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.any((n) => n.id == dailyReminderId);
  }
}
