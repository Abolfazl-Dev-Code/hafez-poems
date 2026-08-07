import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/homeScreenUnit/poemBoxesUnit/action_item.dart';
import 'package:hafez_poems/models/poem_list_config.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poems/poemScreenCacheService/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/PoemsListUnit/poem_list_sheet.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

typedef ShowSheetCallback = void Function(BuildContext context, Widget child);

List<ActionItem> buildPoemBoxActionItems(
  BuildContext context,
  ShowSheetCallback showSheet,
) {
  return [
    ActionItem(
      icon: Image.asset("assets/icons/ghazaliat.png", width: 56, height: 56),
      title: "غزلیات",
      subtitle: "۴۹۵ غزل",
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'غزلیات حافظ',
            loadingText: 'در حال دریافت غزل‌ها...',
            emptyText: 'هیچ غزلی یافت نشد',
            items: Get.find<GhazalCacheService>().cachedGhazalsRx,
            isIndexing: Get.find<GhazalCacheService>().isIndexing,
            loadingProgress: Get.find<GhazalCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<GhazalCacheService>().getGhazalDetail(id).then((_) {}),
            onRetry: Get.find<GhazalCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'ghazal',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              audioUrl: item.audioUrl,
              fetchText: (id) => GhazalLocalService.instance
                  .fetchGhazalById(id)
                  .then((g) => g.text),
              fetchAudioUrl: (id) =>
                  Get.find<GhazalCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),

    ActionItem(
      icon: Image.asset("assets/icons/ghasayed.png", width: 49, height: 49),
      title: "قصاید",
      subtitle: "۳ قصیده",
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'قصاید حافظ',
            loadingText: 'در حال دریافت قصاید...',
            emptyText: 'هیچ قصیده‌ای یافت نشد',
            tilePrefix: 'قصیده شماره',
            items: Get.find<GhasayedCacheService>().cachedQasaidRx,
            isIndexing: Get.find<GhasayedCacheService>().isIndexing,
            loadingProgress: Get.find<GhasayedCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<GhasayedCacheService>().getQasaidDetail(id),
            onRetry: Get.find<GhasayedCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'ghasayed',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              fetchText: (id) => Get.find<GhasayedCacheService>()
                  .getGhasayedDetail(id)
                  .then((d) => d.text),
              fetchAudioUrl: (id) =>
                  Get.find<GhasayedCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),

    ActionItem(
      icon: Image.asset("assets/icons/robaeiyat.png", width: 59, height: 59),
      title: "رباعیات",
      subtitle: "۴۲ رباعی",
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'رباعیات حافظ',
            loadingText: 'در حال دریافت رباعیات...',
            emptyText: 'هیچ رباعی‌ای یافت نشد',
            tilePrefix: 'رباعی شماره',
            items: Get.find<RobaeyatCacheService>().cachedRobaeyatRx,
            isIndexing: Get.find<RobaeyatCacheService>().isIndexing,
            loadingProgress: Get.find<RobaeyatCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<RobaeyatCacheService>().getRobaeyatDetail(id),
            onRetry: Get.find<RobaeyatCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'robaeyat',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              fetchText: (id) => Get.find<RobaeyatCacheService>()
                  .getRobaeyatDetail(id)
                  .then((d) => d.text),
              fetchAudioUrl: (id) =>
                  Get.find<RobaeyatCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),

    ActionItem(
      icon: Image.asset("assets/icons/divan.png", width: 50, height: 50),
      title: "قطعات",
      subtitle: "34 قطعه".toPersianNumbers(),
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'قطعات حافظ',
            loadingText: 'در حال دریافت قطعات...',
            emptyText: 'هیچ قطعه‌ای یافت نشد',
            tilePrefix: 'قطعه شماره',
            items: Get.find<GhataatCacheService>().cachedGhataatRx,
            isIndexing: Get.find<GhataatCacheService>().isIndexing,
            loadingProgress: Get.find<GhataatCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<GhataatCacheService>().getGhataatDetail(id),
            onRetry: Get.find<GhataatCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'ghataat',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              fetchText: (id) => Get.find<GhataatCacheService>()
                  .getGhataatDetail(id)
                  .then((d) => d.text),
              fetchAudioUrl: (id) =>
                  Get.find<GhataatCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),

    ActionItem(
      icon: Image.asset("assets/icons/taabir.png", width: 59, height: 59),
      title: "اشعار منتسب",
      subtitle: "118 شعر منتسب".toPersianNumbers(),
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'اشعار منتسب به حافظ',
            loadingText: 'در حال دریافت اشعار منتسب...',
            emptyText: 'هیچ شعری یافت نشد',
            tilePrefix: 'اشعار منتسب شماره',
            items: Get.find<MontasabCacheService>().cachedMontasabRx,
            isIndexing: Get.find<MontasabCacheService>().isIndexing,
            loadingProgress: Get.find<MontasabCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<MontasabCacheService>().getMontasabDetail(id),
            onRetry: Get.find<MontasabCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'montasab',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              fetchText: (id) => Get.find<MontasabCacheService>()
                  .getMontasabDetail(id)
                  .then((d) => d.text),
              fetchAudioUrl: (id) =>
                  Get.find<MontasabCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),

    ActionItem(
      icon: Image.asset("assets/icons/other.png", width: 59, height: 59),
      title: "اشعار دیگر",
      subtitle: "مثنوی و ساقی‌نامه",
      onTap: () => showSheet(
        context,
        PoemListSheet(
          config: PoemListConfig(
            headerTitle: 'اشعار دیگر',
            loadingText: 'در حال دریافت اشعار...',
            emptyText: 'شعری یافت نشد',
            items: Get.find<OtherPoemCacheService>().cachedOtherPoemsRx,
            isIndexing: Get.find<OtherPoemCacheService>().isIndexing,
            loadingProgress: Get.find<OtherPoemCacheService>().loadingProgress,
            prefetch: (id) =>
                Get.find<OtherPoemCacheService>().getOtherPoemDetail(id),
            onRetry: Get.find<OtherPoemCacheService>().preload,
            buildArgs: (item) => PoemScreenArgs(
              category: 'other',
              id: item.id,
              title: item.title,
              text: item.hasFullText ? item.text : '',
              fetchText: (id) => Get.find<OtherPoemCacheService>()
                  .getOtherPoemDetail(id)
                  .then((d) => d.text),
              fetchAudioUrl: (id) =>
                  Get.find<OtherPoemCacheService>().getAudioUrl(id),
            ),
          ),
        ),
      ),
    ),
  ];
}
