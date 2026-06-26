import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/audio_boot.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/cache_services_boot.dart';
import 'package:hafez_poems/controllers/profile_controller.dart';
import 'package:hafez_poems/controllers/user_actions_controller.dart';
import 'package:hafez_poems/Initializers%20and%20Boot/hive_boot.dart';
import 'package:hafez_poems/services/notification_service.dart';
import 'package:hafez_poems/theme/theme_controller.dart';

class AppInitializer {
  static Future<void> run() async {
    // 1, 2, 3: راه‌اندازی Hive (adapterها + boxها)
    await HiveBoot.init();

    // 4: کنترلرهایی که ممکن است Hive بخواهند
    final themeController = ThemeController();
    await themeController.loadTheme();
    Get.put(themeController, permanent: true);

    Get.put(ProfileController(), permanent: true);

    // 5: سرویس‌های غیر Hive
    await AudioBoot.init();
    await NotificationService.instance.init();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // سرویس‌های کش + UserActionsController + preload
    await CacheServicesBoot.init();
    Get.put<UserActionsController>(UserActionsController(), permanent: true);
    CacheServicesBoot.preloadAll();
  }
}
