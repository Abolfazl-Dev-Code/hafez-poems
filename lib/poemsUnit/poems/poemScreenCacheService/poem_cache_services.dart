import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_logic.dart';
import 'package:hafez_poems/core/data/contracts/i_poem_storage.dart';
import 'package:hafez_poems/models/ghasayed_model.dart';
import 'package:hafez_poems/models/ghataat_model.dart';
import 'package:hafez_poems/models/ghazal_model.dart';
import 'package:hafez_poems/models/montasab_model.dart';
import 'package:hafez_poems/models/other_poem_model.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../poem_local_services.dart';

part '../poem_excerpt.dart';
part 'ghazal_cache_service.dart';
part 'ghataat_cache_service.dart';
part 'robaeyat_cache_service.dart';
part 'montasab_cache_service.dart';
part 'ghasayed_cache_service.dart';
part 'other_poem_cache_service.dart';

// ══════════════════════════════════════════════════════════
//  BASE
// ══════════════════════════════════════════════════════════
abstract class BasePoemCacheService<T> extends GetxService {
  late final IPoemStorage<T> _storage;
  final Map<String, T> _map = {};
  final RxList<T> cachedItemsRx = <T>[].obs;
  late final PoemSearchIndex<T> _searchIndex = PoemSearchIndex<T>(
    idOf: idOf,
    titleOf: titleOf,
    textOf: textOf,
  );
  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;

  // ── housekeeping فایل ذخیره‌سازی ──────────────────
  int _writesSinceCompact = 0;
  static const int _compactThreshold = 15;

  Future<void> _maybeCompact() async {
    _writesSinceCompact++;
    if (_writesSinceCompact >= _compactThreshold) {
      _writesSinceCompact = 0;
      try {
        await _storage.compact();
      } catch (e) {
        debugPrint('$runtimeType compact error: $e');
      }
    }
  }

  String idOf(T item);
  String titleOf(T item);
  String textOf(T item);
  bool hasFullTextOf(T item);
  void setFullText(T item, String text);
  BasePoemLocalService<T> get localService;
  bool get sortById => false;
  int get audioIndex => 0; // قطعات: override با 1
  String get categoryLabel;

  String numberOf(T item) {
    final idx = cachedItemsRx.indexWhere((e) => idOf(e) == idOf(item));
    return idx == -1 ? idOf(item) : '${idx + 1}';
  }

  // ── init ─────────────────────────────────────────
  Future<BasePoemCacheService<T>> init() async {
    _storage = Get.find<IPoemStorage<T>>();

    final all = await _storage.readAll();
    if (all.isNotEmpty) {
      for (final item in all.values) {
        _map[idOf(item)] = item;
      }
      _searchIndex.rebuild(_map.values);
      _assignSorted();
    }
    try {
      await _storage.compact();
    } catch (e) {
      debugPrint('$runtimeType initial compact error: $e');
    }
    return this;
  }

  // ── preload ───────────────────────────────────────
  Future<void> preload() async {
    if (isIndexing.value) return;
    final incomplete = _map.values.where((d) => !hasFullTextOf(d)).toList();
    if (_map.isNotEmpty && incomplete.isEmpty) return;

    isIndexing.value = true;
    loadingProgress.value = 0.0;

    try {
      final list = await localService.fetchList();
      if (list.isEmpty) return;

      final Map<String, T> toSave = {};
      for (int i = 0; i < list.length; i++) {
        final item = list[i];
        final id = idOf(item);
        if (_map.containsKey(id)) {
          final existing = _map[id] as T;
          if (!hasFullTextOf(existing)) {
            setFullText(existing, textOf(item));
            toSave[id] = existing;
          }
        } else {
          _map[id] = item;
          toSave[id] = item;
        }
        loadingProgress.value = (i + 1) / list.length;
      }

      if (toSave.isNotEmpty) {
        await _storage.putAll(toSave);
        try {
          await _storage.compact();
        } catch (e) {
          debugPrint('$runtimeType preload compact error: $e');
        }
      }
      _searchIndex.rebuild(_map.values);
      _assignSorted();
    } catch (e, st) {
      debugPrintStack(label: '$runtimeType preload error: $e', stackTrace: st);
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  // ── getDetail ─────────────────────────────────────
  Future<T> getDetail(String id) async {
    final cached = _map[id];
    if (cached != null && hasFullTextOf(cached)) return cached;

    final item = await localService.fetchById(id);
    _map[id] = item;
    await _storage.put(id, item);
    await _maybeCompact();
    _searchIndex.updateEntry(item);

    final idx = cachedItemsRx.indexWhere((e) => idOf(e) == id);
    if (idx != -1) {
      cachedItemsRx[idx] = item;
    } else {
      cachedItemsRx.add(item);
      if (sortById) cachedItemsRx.sort(_compareItems);
    }
    return item;
  }

  // ── audio ─────────────────────────────────────────
  Future<String> getAudioUrl(String id) async {
    try {
      final url = Uri.parse(
        'https://api.ganjoor.net/api/ganjoor/poem/$id/recitations',
      );
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.length > audioIndex) {
          return data[audioIndex]['mp3Url'] ??
              data[audioIndex]['audioUrl'] ??
              '';
        }
      }
      return '';
    } catch (e) {
      debugPrint('🎵 getAudioUrl error ($id): $e');
      return '';
    }
  }

  // ── search ────────────────────────────────────────
  List<MapEntry<T, int>> searchWithScore(String normalizedQuery) =>
      _searchIndex.searchWithScore(normalizedQuery);

  List<T> search(String normalizedQuery) =>
      _searchIndex.search(normalizedQuery);

  int get cachedCount => _map.length;

  // ── private ───────────────────────────────────────
  void _assignSorted() {
    final items = _map.values.toList();
    if (sortById) items.sort(_compareItems);
    cachedItemsRx.assignAll(items);
  }

  int _compareItems(T a, T b) {
    final ai = int.tryParse(idOf(a));
    final bi = int.tryParse(idOf(b));
    return (ai != null && bi != null)
        ? ai.compareTo(bi)
        : idOf(a).compareTo(idOf(b));
  }
}
