import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/Initializers_and_Boot/audio_boot.dart';
import 'package:hafez_poems/Initializers_and_Boot/cache_services_boot.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/core/data/binding/database_binding.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/notification_service.dart';
import 'package:hafez_poems/theme/theme_controller.dart';

class AppInitializer {
  static Future<void> run() async {
    await DatabaseBinding.init();
    final themeController = ThemeController();
    await themeController.loadTheme();
    Get.put(themeController, permanent: true);
    Get.put(ProfileController(), permanent: true);
    await AudioBoot.init();
    await NotificationService.instance.init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await CacheServicesBoot.init();
    Get.put<UserActionsSaver>(UserActionsSaver(), permanent: true);
    CacheServicesBoot.preloadAll();
  }
}
