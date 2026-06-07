import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/montasab_model.dart';
import '../services/montasab_local_service.dart';

class MontasabCacheService extends GetxService {
  late Box<MontasabModel> _box;

  final Map<String, MontasabModel> _map = {};

  final RxList<MontasabModel> cachedMontasabRx = <MontasabModel>[].obs;

  final List<_IndexedMontasab> _searchIndex = <_IndexedMontasab>[];

  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;

  Future<MontasabCacheService> init() async {
    _box = await Hive.openBox<MontasabModel>('montasab_box');

    if (_box.isNotEmpty) {
      for (final d in _box.values) {
        _map[d.id] = d;
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedMontasabRx.assignAll(items);
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
      final list = await MontasabLocalService.instance.fetchMontasabList();

      if (list.isEmpty) {
        return;
      }

      final Map<String, MontasabModel> toSave = {};

      for (int i = 0; i < list.length; i++) {
        final m = list[i];

        if (_map.containsKey(m.id)) {
          final existing = _map[m.id]!;

          if (!existing.hasFullText) {
            existing
              ..text = m.text
              ..hasFullText = true;

            toSave[existing.id] = existing;
          }
        } else {
          _map[m.id] = m;
          toSave[m.id] = m;
        }

        loadingProgress.value = (i + 1) / list.length;
      }

      if (toSave.isNotEmpty) {
        await _box.putAll(toSave);
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedMontasabRx.assignAll(items);

      loadingProgress.value = 1.0;
    } catch (e, st) {
      debugPrintStack(
        label: 'MontasabCacheService.preload error: $e',
        stackTrace: st,
      );
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  Future<MontasabModel> getMontasabDetail(String id) async {
    final cached = _map[id];

    if (cached != null && cached.hasFullText) {
      return cached;
    }

    final m = await MontasabLocalService.instance.fetchMontasabById(id);

    _map[id] = m;
    await _box.put(id, m);

    _updateIndexEntry(m);

    final idx = cachedMontasabRx.indexWhere((e) => e.id == id);

    if (idx != -1) {
      cachedMontasabRx[idx] = m;
    } else {
      cachedMontasabRx.add(m);
      cachedMontasabRx.sort((a, b) => _compareIds(a.id, b.id));
    }

    return m;
  }

  int get cachedCount => _map.length;

  List<MontasabModel> search(String normalizedQuery) {
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
    for (final d in _map.values) {
      _searchIndex.add(_toIndexed(d));
    }
  }

  void _updateIndexEntry(MontasabModel d) {
    final idx = _searchIndex.indexWhere((e) => e.original.id == d.id);
    final entry = _toIndexed(d);

    if (idx != -1) {
      _searchIndex[idx] = entry;
    } else {
      _searchIndex.add(entry);
    }
  }

  _IndexedMontasab _toIndexed(MontasabModel d) {
    return _IndexedMontasab(
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

class _IndexedMontasab {
  final MontasabModel original;
  final String normalizedTitle;
  final String normalizedText;

  const _IndexedMontasab({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
  });
}
