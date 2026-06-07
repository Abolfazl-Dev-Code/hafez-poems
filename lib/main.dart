import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/controllers/ghazal_action_controller.dart';
import 'package:hafez_poems/controllers/ghazal_controller.dart';
import 'package:hafez_poems/models/ghasayed_model.dart';
import 'package:hafez_poems/models/ghazal_model.dart';
import 'package:hafez_poems/models/ghataat_model.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/montasab_model.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/screens/splash_screen.dart';
import 'package:hafez_poems/services/ghasayed_cache_service.dart';
import 'package:hafez_poems/services/ghataat_cache_service.dart';
import 'package:hafez_poems/services/ghazal_cache_service_offline.dart';
import 'package:hafez_poems/services/montasab_cache_service.dart';
import 'package:hafez_poems/services/notification_service.dart';
import 'package:hafez_poems/services/robaeyat_cache_service.dart';
import 'package:hafez_poems/services/theme_reveal_service.dart';
import 'package:hafez_poems/theme/app_theme.dart';
import 'package:hafez_poems/theme/theme_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<Box<T>> openBoxSafely<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } catch (e) {
    if (Hive.isBoxOpen(name)) await Hive.box(name).close();
    await Hive.deleteBoxFromDisk(name);
    return await Hive.openBox<T>(name);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  final themeController = ThemeController();
  await themeController.loadTheme();
  Get.put(themeController, permanent: true);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Hive.initFlutter();
  Hive.registerAdapter(LikedItemAdapter());
  Hive.registerAdapter(SavedItemAdapter());
  Hive.registerAdapter(HighlightItemAdapter());
  Hive.registerAdapter(GhazalAdapter());
  Hive.registerAdapter(GhataatModelAdapter());
  Hive.registerAdapter(GhasayedModelAdapter());
  Hive.registerAdapter(RobaeyatModelAdapter());
  Hive.registerAdapter(MontasabModelAdapter());

  await Future.wait<Box>([
    openBoxSafely<LikedItem>(GhazalActionController.likedBoxName),
    openBoxSafely<SavedItem>(GhazalActionController.savedBoxName),
    openBoxSafely<HighlightItem>(GhazalActionController.highlightBoxName),
    openBoxSafely<dynamic>(
      'profile_box',
    ), // از dynamic برای باکس‌های بدون مدل استفاده کنید
    openBoxSafely<Ghazal>('ghazals_box'),
    openBoxSafely<GhataatModel>('ghataat_box'),
    openBoxSafely<GhasayedModel>('qasaid_box'),
    openBoxSafely<RobaeyatModel>('robaeyat_box'),
    openBoxSafely<MontasabModel>('montasab_box'),
  ]);
  // Ghazal
  final ghazalCache = GhazalCacheService();
  Get.put<GhazalCacheService>(ghazalCache, permanent: true);
  await ghazalCache.init();

  // Ghataat
  final ghataatCache = GhataatCacheService();
  Get.put<GhataatCacheService>(ghataatCache, permanent: true);
  await ghataatCache.init();

  // Ghasayed
  final ghasayedCache = GhasayedCacheService();
  Get.put<GhasayedCacheService>(ghasayedCache, permanent: true);
  await ghasayedCache.init();

  // Robaeyat
  final robaeyatCache = RobaeyatCacheService();
  Get.put<RobaeyatCacheService>(robaeyatCache, permanent: true);
  await robaeyatCache.init();

  final montasabCache = MontasabCacheService();
  Get.put<MontasabCacheService>(montasabCache, permanent: true);
  await montasabCache.init();

  // این کد را فقط یک بار اجرا کنید تا مطمئن شوید دیتای قدیمی باعث خطا نمی‌شود
  // await Hive.deleteBoxFromDisk('ghazals_box');
  Get.put<GhazalController>(GhazalController(), permanent: true);
  Get.put<GhazalActionController>(GhazalActionController(), permanent: true);

  ghazalCache.preload();
  ghataatCache.preload();
  ghasayedCache.preload();
  robaeyatCache.preload();
  montasabCache.preload();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => RepaintBoundary(
        key: ThemeRevealService.instance.repaintKey,
        child: GetMaterialApp(
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
