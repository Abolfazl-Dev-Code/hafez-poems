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
import 'poem_local_services.dart';

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

  // ── زیرکلاس پیاده‌سازی می‌کند ──────────────────
  String idOf(T item);
  String titleOf(T item);
  String textOf(T item);
  bool hasFullTextOf(T item);
  void setFullText(T item, String text);
  BasePoemLocalService<T> get localService;
  bool get sortById => false;
  int get audioIndex => 0; // قطعات: override با 1

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

// ══════════════════════════════════════════════════════════
//  GHAZAL
// ══════════════════════════════════════════════════════════

class GhazalExcerpt {
  final String id;
  final String number;
  final String excerpt;

  const GhazalExcerpt({
    required this.id,
    required this.number,
    required this.excerpt,
  });
}

class GhazalCacheService extends BasePoemCacheService<Ghazal> {
  @override
  String idOf(Ghazal g) => g.id;
  @override
  String titleOf(Ghazal g) => g.title;
  @override
  String textOf(Ghazal g) => g.text;
  @override
  bool hasFullTextOf(Ghazal g) => g.hasFullText;
  @override
  void setFullText(Ghazal g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhazalLocalService get localService => GhazalLocalService.instance;

  final RxInt textsReadyCount = 0.obs;

  Future<void> updateAudioUrl(String id, String url) async {
    final ghazal = _map[id];
    if (ghazal != null) {
      ghazal.audioUrl = url;
      await _storage.put(id, ghazal);
      await _maybeCompact();
    }
  }

  @override
  Future<String> getAudioUrl(String id) async {
    final cached = _map[id];
    if (cached != null && cached.audioUrl.isNotEmpty) return cached.audioUrl;
    return super.getAudioUrl(id);
  }

  Ghazal? randomGhazal() {
    final valid = _map.values.where((g) => g.hasFullText).toList();
    if (valid.isEmpty) return null;
    return (valid..shuffle(Random())).first;
  }

  List<GhazalExcerpt> randomExcerpts({int count = 5}) {
    final valid =
        _map.values
            .where((g) => g.hasFullText && g.text.trim().isNotEmpty)
            .toList()
          ..shuffle(Random());
    final result = <GhazalExcerpt>[];
    for (final g in valid) {
      final excerpt = _extractFirstFourBeyts(g.text);
      if (excerpt.isNotEmpty) {
        final number = _extractGhazalNumber(g.title);
        result.add(
          GhazalExcerpt(
            id: g.id,
            number: number.isNotEmpty ? number : g.id,
            excerpt: excerpt,
          ),
        );
        if (result.length >= count) break;
      }
    }
    return result;
  }

  String _extractGhazalNumber(String title) {
    final matches = RegExp(
      r'[0-9\u06F0-\u06F9\u0660-\u0669]+',
    ).allMatches(title).toList();
    if (matches.isEmpty) return '';
    return matches.last.group(0) ?? '';
  }

  String _extractFirstFourBeyts(String text) {
    final lines = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) return '';
    final beyts = <String>[];
    for (int i = 0; i < lines.length && beyts.length < 4; i += 2) {
      final m2 = (i + 1 < lines.length) ? lines[i + 1] : '';
      beyts.add(m2.isNotEmpty ? '${lines[i]}\n$m2' : lines[i]);
    }
    return beyts.join('\n\n');
  }

  RxList<Ghazal> get cachedGhazalsRx => cachedItemsRx;
  List<Ghazal> get cachedGhazals => cachedItemsRx.toList();
  Future<Ghazal> getGhazalDetail(String id) => getDetail(id);
}

// ══════════════════════════════════════════════════════════
//  GHATAAT
// ══════════════════════════════════════════════════════════

class GhataatCacheService extends BasePoemCacheService<GhataatModel> {
  @override
  int get audioIndex => 1;
  @override
  String idOf(GhataatModel g) => g.id;
  @override
  String titleOf(GhataatModel g) => g.title;
  @override
  String textOf(GhataatModel g) => g.text;
  @override
  bool hasFullTextOf(GhataatModel g) => g.hasFullText;
  @override
  void setFullText(GhataatModel g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhataatLocalService get localService => GhataatLocalService.instance;

  Future<GhataatModel> getGhataatDetail(String id) => getDetail(id);
  RxList<GhataatModel> get cachedGhataatRx => cachedItemsRx;
}

// ══════════════════════════════════════════════════════════
//  ROBAEYAT
// ══════════════════════════════════════════════════════════

class RobaeyatCacheService extends BasePoemCacheService<RobaeyatModel> {
  @override
  bool get sortById => true;
  @override
  String idOf(RobaeyatModel r) => r.id;
  @override
  String titleOf(RobaeyatModel r) => r.title;
  @override
  String textOf(RobaeyatModel r) => r.text;
  @override
  bool hasFullTextOf(RobaeyatModel r) => r.hasFullText;
  @override
  void setFullText(RobaeyatModel r, String text) {
    r.text = text;
    r.hasFullText = true;
  }

  @override
  RobaeyatLocalService get localService => RobaeyatLocalService.instance;

  Future<RobaeyatModel> getRobaeyatDetail(String id) => getDetail(id);
  RxList<RobaeyatModel> get cachedRobaeyatRx => cachedItemsRx;
}

// ══════════════════════════════════════════════════════════
//  MONTASAB
// ══════════════════════════════════════════════════════════

class MontasabCacheService extends BasePoemCacheService<MontasabModel> {
  @override
  bool get sortById => true;
  @override
  String idOf(MontasabModel m) => m.id;
  @override
  String titleOf(MontasabModel m) => m.title;
  @override
  String textOf(MontasabModel m) => m.text;
  @override
  bool hasFullTextOf(MontasabModel m) => m.hasFullText;
  @override
  void setFullText(MontasabModel m, String text) {
    m.text = text;
    m.hasFullText = true;
  }

  @override
  MontasabLocalService get localService => MontasabLocalService.instance;

  Future<MontasabModel> getMontasabDetail(String id) => getDetail(id);
  RxList<MontasabModel> get cachedMontasabRx => cachedItemsRx;
}

// ══════════════════════════════════════════════════════════
//  GHASAYED
// ══════════════════════════════════════════════════════════

class GhasayedCacheService extends BasePoemCacheService<GhasayedModel> {
  @override
  bool get sortById => true;
  @override
  String idOf(GhasayedModel g) => g.id;
  @override
  String titleOf(GhasayedModel g) => g.title;
  @override
  String textOf(GhasayedModel g) => g.text;
  @override
  bool hasFullTextOf(GhasayedModel g) => g.hasFullText;
  @override
  void setFullText(GhasayedModel g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhasayedLocalService get localService => GhasayedLocalService.instance;

  RxList<GhasayedModel> get cachedQasaidRx => cachedItemsRx;
  RxList<GhasayedModel> get cachedGhasayedRx => cachedItemsRx;
  Future<GhasayedModel> getQasaidDetail(String id) => getDetail(id);
  Future<GhasayedModel> getGhasayedDetail(String id) => getDetail(id);
}

// ══════════════════════════════════════════════════════════
//  OTHER POEMS (مثنوی + ساقی‌نامه)
// ══════════════════════════════════════════════════════════

class OtherPoemCacheService extends BasePoemCacheService<OtherPoemModel> {
  @override
  String idOf(OtherPoemModel o) => o.id;
  @override
  String titleOf(OtherPoemModel o) => o.title;
  @override
  String textOf(OtherPoemModel o) => o.text;
  @override
  bool hasFullTextOf(OtherPoemModel o) => o.hasFullText;
  @override
  void setFullText(OtherPoemModel o, String text) {
    o.text = text;
    o.hasFullText = true;
  }

  @override
  OtherPoemLocalService get localService => OtherPoemLocalService.instance;

  Future<OtherPoemModel> getOtherPoemDetail(String id) => getDetail(id);
  RxList<OtherPoemModel> get cachedOtherPoemsRx => cachedItemsRx;
}
