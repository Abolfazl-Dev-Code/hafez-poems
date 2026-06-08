import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';
import 'package:hafez_poems/services/robaeyat_local_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class RobaeyatCacheService extends GetxService {
  late Box<RobaeyatModel> _box;

  final Map<String, RobaeyatModel> _map = {};

  final RxList<RobaeyatModel> cachedRobaeyatRx = <RobaeyatModel>[].obs;

  final List<_IndexedRobaeyat> _searchIndex = <_IndexedRobaeyat>[];

  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;

  Future<RobaeyatCacheService> init() async {
    _box = await Hive.openBox<RobaeyatModel>('robaeyat_box');

    if (_box.isNotEmpty) {
      for (final d in _box.values) {
        _map[d.id] = d;
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedRobaeyatRx.assignAll(items);
    }
    return this;
  }

  // در GhataatCacheService — بعد از getGhataatDetail
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
        if (data.isNotEmpty) {
          return data[0]['mp3Url'] ?? data[0]['audioUrl'] ?? '';
        }
      }
      return '';
    } catch (e) {
      debugPrint('🎵 [CACHE] getAudioUrl error ($id): $e');
      return '';
    }
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
      final list = await RobaeyatLocalService.instance.fetchRobaeyatList();

      if (list.isEmpty) {
        return;
      }

      final Map<String, RobaeyatModel> toSave = {};

      for (int i = 0; i < list.length; i++) {
        final r = list[i];

        if (_map.containsKey(r.id)) {
          final existing = _map[r.id]!;

          if (!existing.hasFullText) {
            existing
              ..text = r.text
              ..hasFullText = true;

            toSave[existing.id] = existing;
          }
        } else {
          _map[r.id] = r;
          toSave[r.id] = r;
        }

        loadingProgress.value = (i + 1) / list.length;
      }

      if (toSave.isNotEmpty) {
        await _box.putAll(toSave);
      }

      _rebuildSearchIndex();

      final items = _map.values.toList()
        ..sort((a, b) => _compareIds(a.id, b.id));

      cachedRobaeyatRx.assignAll(items);

      loadingProgress.value = 1.0;
    } catch (e, st) {
      debugPrintStack(
        label: 'RobaeyatCacheService.preload error: $e',
        stackTrace: st,
      );
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  Future<RobaeyatModel> getRobaeyatDetail(String id) async {
    final cached = _map[id];

    if (cached != null && cached.hasFullText) {
      return cached;
    }

    final r = await RobaeyatLocalService.instance.fetchRobaeyatById(id);

    _map[id] = r;

    await _box.put(id, r);

    _updateIndexEntry(r);

    final idx = cachedRobaeyatRx.indexWhere((e) => e.id == id);

    if (idx != -1) {
      cachedRobaeyatRx[idx] = r;
    } else {
      cachedRobaeyatRx.add(r);
      cachedRobaeyatRx.sort((a, b) => _compareIds(a.id, b.id));
    }

    return r;
  }

  int get cachedCount => _map.length;

  List<RobaeyatModel> search(String normalizedQuery) {
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

  void _updateIndexEntry(RobaeyatModel d) {
    final idx = _searchIndex.indexWhere((e) => e.original.id == d.id);

    final entry = _toIndexed(d);

    if (idx != -1) {
      _searchIndex[idx] = entry;
    } else {
      _searchIndex.add(entry);
    }
  }

  _IndexedRobaeyat _toIndexed(RobaeyatModel d) {
    return _IndexedRobaeyat(
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

class _IndexedRobaeyat {
  final RobaeyatModel original;
  final String normalizedTitle;
  final String normalizedText;

  const _IndexedRobaeyat({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
  });
}
