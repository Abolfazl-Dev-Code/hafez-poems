import 'dart:async';
import 'package:get/get.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/poemsUnit/poems/poemScreenCacheService/poem_cache_services.dart';
import 'search_logic.dart';

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

    final type = selectedType.value;

    if (type == null || type == SearchResultType.ghazal) {
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
    }

    if (type == null || type == SearchResultType.ghataat) {
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
    }

    if (type == null || type == SearchResultType.qasaid) {
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
    }

    if (type == null || type == SearchResultType.robaeyat) {
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
    }

    if (type == null || type == SearchResultType.montasab) {
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
    }

    if (type == null || type == SearchResultType.other) {
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
    }

    scoredList.sort((a, b) => b.value.compareTo(a.value));

    results.value = scoredList.map((e) => e.key).take(_maxResults).toList();
  }
}

String normalize(String text) => normalizeText(text);
