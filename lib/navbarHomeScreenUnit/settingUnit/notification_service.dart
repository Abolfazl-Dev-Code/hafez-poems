import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/greetingUnit/greeting_schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_settings_storage.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const int dailyReminderId = 1001;
  static const MethodChannel _channel = MethodChannel('hafez/notifications');
  late final ISettingsStorage _settings = Get.find<ISettingsStorage>();

  Future<void> init() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'daily_hafez_reminder',
        channelName: 'یادآوری روزانه حافظ',
        channelDescription: 'اعلان یادآوری روزانه برای خواندن دیوان حافظ',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ], debug: false);
  }

  Future<bool> requestNotificationPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) return true;
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Future<bool> requestExactAlarmPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications(
      permissions: [NotificationPermission.PreciseAlarms],
    );
  }

  Future<bool> requestReminderPermissions() async {
    final notifGranted = await requestNotificationPermission();
    if (!notifGranted) return false;
    return await requestExactAlarmPermission();
  }

  Future<void> showRtlNotification({
    required String title,
    required String body,
    int id = dailyReminderId,
  }) async {
    try {
      await _channel.invokeMethod('showRtlNotification', {
        'title': title,
        'body': body,
        'id': id,
      });
      // ignore: empty_catches
    } catch (e) {}
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

    final userName = (_settings.get<String>('name') ?? '').trim();

    final baseTitle = GreetingNotificationContent.titleForHour(hour);

    final title = userName.isEmpty ? baseTitle : '$baseTitle $userName';
    final body = GreetingNotificationContent.bodyForHour(hour);

    try {
      await _channel.invokeMethod('scheduleDailyRtlNotification', {
        'title': title,
        'body': body,
        'hour': hour,
        'minute': minute,
        'id': dailyReminderId,
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> cancelDailyReminder() async {
    try {
      await _channel.invokeMethod('cancelDailyRtlNotification', {
        'id': dailyReminderId,
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<bool> isDailyReminderScheduled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isDailyReminderScheduled',
        {'id': dailyReminderId},
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
