import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/ghasayed_model.dart';
import '../services/ghasayed_local_service.dart';

class GhasayedCacheService extends GetxService {
  late Box<GhasayedModel> _box;

  final Map<String, GhasayedModel> _map = {};

  final RxList<GhasayedModel> cachedGhasayedRx = <GhasayedModel>[].obs;
  RxList<GhasayedModel> get cachedQasaidRx => cachedGhasayedRx;

  final List<_IndexedGhasayed> _searchIndex = <_IndexedGhasayed>[];

  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;

  Future<GhasayedCacheService> init() async {
    _box = await Hive.openBox<GhasayedModel>('ghasayed_box');

    if (_box.isNotEmpty) {
      for (final d in _box.values) {
        _map[d.id] = d;
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedGhasayedRx.assignAll(items);
    }
    return this;
  }

  Future<void> preload() async {
    if (isIndexing.value) return;

    final incomplete = _map.values.where((d) => !d.hasFullText).toList();

    if (_map.isNotEmpty && incomplete.isEmpty) {
      return;
    }

    isIndexing.value = true;
    loadingProgress.value = 0.0;

    try {
      final list = await GhasayedLocalService.instance.fetchQasaidList();

      if (list.isEmpty) {
        return;
      }

      final Map<String, GhasayedModel> toSave = {};

      for (int i = 0; i < list.length; i++) {
        final g = list[i];

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

        loadingProgress.value = (i + 1) / list.length;
      }

      if (toSave.isNotEmpty) {
        await _box.putAll(toSave);
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedGhasayedRx.assignAll(items);

      loadingProgress.value = 1.0;
    } catch (e, st) {
      debugPrintStack(
        label: 'GhasayedCacheService.preload error: $e',
        stackTrace: st,
      );
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  Future<GhasayedModel> getGhasayedDetail(String id) async {
    final cached = _map[id];

    if (cached != null && cached.hasFullText) {
      return cached;
    }

    final g = await GhasayedLocalService.instance.fetchQasaidById(id);

    _map[id] = g;

    await _box.put(id, g);

    _updateIndexEntry(g);

    final idx = cachedGhasayedRx.indexWhere((e) => e.id == id);

    if (idx != -1) {
      cachedGhasayedRx[idx] = g;
    } else {
      cachedGhasayedRx.add(g);
      cachedGhasayedRx.sort((a, b) => _compareIds(a.id, b.id));
    }

    return g;
  }

  int get cachedCount => _map.length;

  List<GhasayedModel> search(String normalizedQuery) {
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

  Future<GhasayedModel> getQasaidDetail(String id) {
    return getGhasayedDetail(id);
  }

  void _rebuildSearchIndex() {
    _searchIndex.clear();

    for (final d in _map.values) {
      _searchIndex.add(_toIndexed(d));
    }
  }

  void _updateIndexEntry(GhasayedModel d) {
    final idx = _searchIndex.indexWhere((e) => e.original.id == d.id);

    final entry = _toIndexed(d);

    if (idx != -1) {
      _searchIndex[idx] = entry;
    } else {
      _searchIndex.add(entry);
    }
  }

  _IndexedGhasayed _toIndexed(GhasayedModel d) {
    return _IndexedGhasayed(
      original: d,
      normalizedTitle: _normalize(d.title),
      normalizedText: _normalize(d.text),
    );
  }

  String _normalize(String text) {
    return text
        .replaceAll('\u064a', '\u06cc')
        .replaceAll('\u0643', '\u06a9')
        .replaceAll('\u200c', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();
  }

  int _compareIds(String a, String b) {
    final ai = int.tryParse(a);
    final bi = int.tryParse(b);

    if (ai != null && bi != null) {
      return ai.compareTo(bi);
    }

    return a.compareTo(b);
  }
}

class _IndexedGhasayed {
  final GhasayedModel original;
  final String normalizedTitle;
  final String normalizedText;

  const _IndexedGhasayed({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
  });
}
