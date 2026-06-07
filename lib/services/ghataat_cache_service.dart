import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/ghataat_model.dart';
import '../services/ghataat_local_service.dart';

class GhataatCacheService extends GetxService {
  late Box<GhataatModel> _box;

  final Map<String, GhataatModel> _map = {};
  final RxList<GhataatModel> cachedGhataatRx = <GhataatModel>[].obs;
  final List<_IndexedGhataat> _searchIndex = [];

  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;

  Future<GhataatCacheService> init() async {
    _box = Hive.box<GhataatModel>('ghataat_box');

    if (_box.isNotEmpty) {
      for (final d in _box.values) {
        _map[d.id] = d;
      }
      _rebuildSearchIndex();
      cachedGhataatRx.assignAll(_map.values.toList());
    }
    return this;
  }

  Future<void> preload() async {
    if (isIndexing.value) return;

    final incomplete = _map.values.where((d) => !d.hasFullText).toList();
    if (_map.isNotEmpty && incomplete.isEmpty) return;

    isIndexing.value = true;
    loadingProgress.value = 0;

    try {
      final list = await GhataatLocalService.instance.fetchGhataatList();
      if (list.isEmpty) return;

      final Map<String, GhataatModel> toSave = {};

      for (final g in list) {
        if (_map.containsKey(g.id)) {
          final existing = _map[g.id]!;
          if (!existing.hasFullText) {
            existing
              ..text = g.text
              ..hasFullText = true;
            toSave[existing.id] = existing;
          }
        } else {
          _map[g.id] = g;
          toSave[g.id] = g;
        }
      }

      if (toSave.isNotEmpty) await _box.putAll(toSave);

      _rebuildSearchIndex();
      cachedGhataatRx.assignAll(_map.values.toList());
      loadingProgress.value = 1.0;
    } catch (e, st) {
      debugPrintStack(
        label: 'GhataatCacheService.preload error: $e',
        stackTrace: st,
      );
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  Future<GhataatModel> getGhataatDetail(String id) async {
    final cached = _map[id];
    if (cached != null && cached.hasFullText) return cached;

    final g = await GhataatLocalService.instance.fetchGhataatById(id);
    _map[id] = g;
    await _box.put(id, g);
    _updateIndexEntry(g);
    final idx = cachedGhataatRx.indexWhere((e) => e.id == id);
    if (idx != -1) cachedGhataatRx[idx] = g;
    return g;
  }

  int get cachedCount => _map.length;

  List<GhataatModel> search(String normalizedQuery) {
    if (normalizedQuery.trim().isEmpty) return [];
    return _searchIndex
        .where(
          (g) =>
              g.normalizedTitle.contains(normalizedQuery) ||
              g.normalizedText.contains(normalizedQuery),
        )
        .map((e) => e.original)
        .take(100)
        .toList();
  }

  void _rebuildSearchIndex() {
    _searchIndex.clear();
    _searchIndex.addAll(_map.values.map(_toIndexed));
  }

  void _updateIndexEntry(GhataatModel d) {
    final idx = _searchIndex.indexWhere((e) => e.original.id == d.id);
    final entry = _toIndexed(d);
    if (idx != -1) {
      _searchIndex[idx] = entry;
    } else {
      _searchIndex.add(entry);
    }
  }

  _IndexedGhataat _toIndexed(GhataatModel d) => _IndexedGhataat(
    original: d,
    normalizedTitle: _normalize(d.title),
    normalizedText: _normalize(d.text),
  );

  String _normalize(String text) => text
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}

class _IndexedGhataat {
  final GhataatModel original;
  final String normalizedTitle;
  final String normalizedText;
  const _IndexedGhataat({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
  });
}
