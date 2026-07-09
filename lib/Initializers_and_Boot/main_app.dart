import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/route_observer_screen.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/theme_reveal_service.dart';
import 'package:hafez_poems/onboardingSplashUnit/splash_screen.dart';
import 'package:hafez_poems/theme/app_theme.dart';
import 'package:hafez_poems/theme/theme_controller.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => RepaintBoundary(
        key: ThemeRevealService.instance.repaintKey,
        child: GetMaterialApp(
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
