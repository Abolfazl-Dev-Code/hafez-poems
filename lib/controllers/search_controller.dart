import 'dart:async';
import 'package:get/get.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';

class SearchController extends GetxController {
  final searchText = ''.obs;
  final results = <SearchResult>[].obs;

  final selectedType = Rx<SearchResultType?>(null);

  final isIndexing = false.obs;
  final progress = 0.0.obs;
  final cachedCount = 0.obs;

  Timer? debounce;

  final GhazalCacheService ghazalCache = Get.find();
  final GhataatCacheService ghataatCache = Get.find();
  final GhasayedCacheService ghasayedCache = Get.find();
  final RobaeyatCacheService robaeyatCache = Get.find();
  final MontasabCacheService montasabCache = Get.find();
  final OtherPoemCacheService otherPoemCache = Get.find();

  @override
  void onInit() {
    super.onInit();

    ever(searchText, (_) => _debouncedSearch());

    ever(ghazalCache.isIndexing, (v) => isIndexing.value = v);
    ever(ghazalCache.loadingProgress, (v) => progress.value = v);

    ever(ghazalCache.cachedGhazalsRx, (_) {
      cachedCount.value = totalCachedCount;
    });

    cachedCount.value = totalCachedCount;
  }

  int get totalCachedCount =>
      ghazalCache.cachedCount +
      ghataatCache.cachedCount +
      ghasayedCache.cachedCount +
      robaeyatCache.cachedCount +
      montasabCache.cachedCount +
      otherPoemCache.cachedCount;

  void _debouncedSearch() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 250), performSearch);
  }

  void performSearch() {
    final query = normalize(searchText.value);

    if (query.isEmpty) {
      results.clear();
      return;
    }

    final list = <SearchResult>[];

    list.addAll(
      ghazalCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: g.audioUrl,
              type: SearchResultType.ghazal,
            ),
          ),
    );

    list.addAll(
      ghataatCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.ghataat,
            ),
          ),
    );

    list.addAll(
      ghasayedCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.qasaid,
            ),
          ),
    );

    list.addAll(
      robaeyatCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.robaeyat,
            ),
          ),
    );

    list.addAll(
      montasabCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.montasab,
            ),
          ),
    );

    list.addAll(
      otherPoemCache
          .search(query)
          .map(
            (o) => SearchResult(
              id: o.id,
              title: o.title,
              text: o.text,
              audioUrl: '',
              type: SearchResultType.other,
            ),
          ),
    );

    if (selectedType.value != null) {
      results.value = list.where((e) => e.type == selectedType.value).toList();
    } else {
      results.value = list;
    }
  }
}

String normalize(String text) {
  return text
      .replaceAll('۰', '0')
      .replaceAll('٠', '0')
      .replaceAll('۱', '1')
      .replaceAll('١', '1')
      .replaceAll('۲', '2')
      .replaceAll('٢', '2')
      .replaceAll('۳', '3')
      .replaceAll('٣', '3')
      .replaceAll('۴', '4')
      .replaceAll('٤', '4')
      .replaceAll('۵', '5')
      .replaceAll('٥', '5')
      .replaceAll('۶', '6')
      .replaceAll('٦', '6')
      .replaceAll('۷', '7')
      .replaceAll('٧', '7')
      .replaceAll('۸', '8')
      .replaceAll('٨', '8')
      .replaceAll('۹', '9')
      .replaceAll('٩', '9')
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}
