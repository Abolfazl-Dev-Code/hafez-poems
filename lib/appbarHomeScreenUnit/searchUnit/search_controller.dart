import 'dart:async';
import 'package:get/get.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';

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
  static const int _minQueryLength = 2;
  static const int _maxResults = 50;

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

  @override
  void onClose() {
    debounce?.cancel();
    super.onClose();
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
    debounce = Timer(const Duration(milliseconds: 400), performSearch);
  }

  void performSearch() {
    final query = normalize(searchText.value);

    if (query.length < _minQueryLength) {
      results.clear();
      return;
    }

    final scoredList = <MapEntry<SearchResult, int>>[];

    void addScored<T>(
      List<MapEntry<T, int>> items,
      SearchResult Function(T) toResult,
    ) {
      for (final e in items) {
        scoredList.add(MapEntry(toResult(e.key), e.value));
      }
    }

    addScored(
      ghazalCache.searchWithScore(query),
      (g) => SearchResult(
        id: g.id,
        title: g.title,
        text: g.text,
        audioUrl: g.audioUrl,
        type: SearchResultType.ghazal,
      ),
    );

    addScored(
      ghataatCache.searchWithScore(query),
      (g) => SearchResult(
        id: g.id,
        title: g.title,
        text: g.text,
        audioUrl: '',
        type: SearchResultType.ghataat,
      ),
    );

    addScored(
      ghasayedCache.searchWithScore(query),
      (g) => SearchResult(
        id: g.id,
        title: g.title,
        text: g.text,
        audioUrl: '',
        type: SearchResultType.qasaid,
      ),
    );

    addScored(
      robaeyatCache.searchWithScore(query),
      (g) => SearchResult(
        id: g.id,
        title: g.title,
        text: g.text,
        audioUrl: '',
        type: SearchResultType.robaeyat,
      ),
    );

    addScored(
      montasabCache.searchWithScore(query),
      (g) => SearchResult(
        id: g.id,
        title: g.title,
        text: g.text,
        audioUrl: '',
        type: SearchResultType.montasab,
      ),
    );

    addScored(
      otherPoemCache.searchWithScore(query),
      (o) => SearchResult(
        id: o.id,
        title: o.title,
        text: o.text,
        audioUrl: '',
        type: SearchResultType.other,
      ),
    );

    final filtered = selectedType.value != null
        ? scoredList.where((e) => e.key.type == selectedType.value).toList()
        : scoredList;

    filtered.sort((a, b) => b.value.compareTo(a.value));

    results.value = filtered.map((e) => e.key).take(_maxResults).toList();
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
