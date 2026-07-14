import 'package:get/get.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';

class PoemCategoryResolver {
  PoemCategoryResolver._();

  static Future<String> Function(String id) fetchTextFor(String category) {
    switch (category) {
      case 'ghazal':
        return (id) =>
            GhazalLocalService.instance.fetchGhazalById(id).then((g) => g.text);
      case 'ghataat':
        return (id) => Get.find<GhataatCacheService>()
            .getGhataatDetail(id)
            .then((d) => d.text);
      case 'ghasayed':
        return (id) => Get.find<GhasayedCacheService>()
            .getGhasayedDetail(id)
            .then((d) => d.text);
      case 'robaeyat':
        return (id) => Get.find<RobaeyatCacheService>()
            .getRobaeyatDetail(id)
            .then((d) => d.text);
      case 'montasab':
        return (id) => Get.find<MontasabCacheService>()
            .getMontasabDetail(id)
            .then((d) => d.text);
      case 'other':
        return (id) => Get.find<OtherPoemCacheService>()
            .getOtherPoemDetail(id)
            .then((d) => d.text);
      default:
        return (id) async => '';
    }
  }

  static Future<String> Function(String id) fetchAudioUrlFor(String category) {
    switch (category) {
      case 'ghazal':
        return (id) => Get.find<GhazalCacheService>().getAudioUrl(id);
      case 'ghataat':
        return (id) => Get.find<GhataatCacheService>().getAudioUrl(id);
      case 'ghasayed':
        return (id) => Get.find<GhasayedCacheService>().getAudioUrl(id);
      case 'robaeyat':
        return (id) => Get.find<RobaeyatCacheService>().getAudioUrl(id);
      case 'montasab':
        return (id) => Get.find<MontasabCacheService>().getAudioUrl(id);
      case 'other':
        return (id) => Get.find<OtherPoemCacheService>().getAudioUrl(id);
      default:
        return (id) async => '';
    }
  }
}
