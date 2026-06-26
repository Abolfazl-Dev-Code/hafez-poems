import 'package:get/get.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';

class CacheServicesBoot {
  static Future<void> init() async {
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

    // Montasab
    final montasabCache = MontasabCacheService();
    Get.put<MontasabCacheService>(montasabCache, permanent: true);
    await montasabCache.init();

    // Other Poems (مثنوی + ساقی‌نامه)
    final otherPoemCache = OtherPoemCacheService();
    Get.put<OtherPoemCacheService>(otherPoemCache, permanent: true);
    await otherPoemCache.init();
  }

  static void preloadAll() {
    Get.find<GhazalCacheService>().preload();
    Get.find<GhataatCacheService>().preload();
    Get.find<GhasayedCacheService>().preload();
    Get.find<RobaeyatCacheService>().preload();
    Get.find<MontasabCacheService>().preload();
    Get.find<OtherPoemCacheService>().preload();
  }
}
