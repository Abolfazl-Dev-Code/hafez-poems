import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/ghazal_model.dart';
import '../services/ghazal_local_service.dart';
import 'package:collection/collection.dart';

class GhazalCacheService extends GetxService {
  late Box<Ghazal> _box;

  final Map<String, Ghazal> _ghazalMap = {};
  final RxList<Ghazal> cachedGhazalsRx = <Ghazal>[].obs;
  final List<_IndexedGhazal> _searchIndex = [];

  final RxDouble loadingProgress = 0.0.obs;
  final RxBool isIndexing = false.obs;
  final RxInt textsReadyCount = 0.obs;

  bool get isLoaded => _ghazalMap.isNotEmpty;
  List<Ghazal> get cachedGhazals => _ghazalMap.values.toList();
  int get cachedCount => _ghazalMap.length;

  Future<GhazalCacheService> init() async {
    _box = Hive.box<Ghazal>('ghazals_box');

    if (_box.isNotEmpty) {
      for (final g in _box.values) {
        _ghazalMap[g.id] = g;
      }
      _rebuildSearchIndex();
      cachedGhazalsRx.assignAll(_ghazalMap.values.toList());
    }

    return this;
  }

  Future<void> updateAudioUrl(String id, String url) async {
    final box = await Hive.openBox<Ghazal>('ghazals_box');
    final ghazal = box.values.firstWhereOrNull((g) => g.id == id);
    if (ghazal != null) {
      ghazal.audioUrl = url;
      await ghazal.save();
    }
  }

  Future<String> getAudioUrl(String id) async {
    final cached = _ghazalMap[id];
    if (cached != null && cached.audioUrl.isNotEmpty) return cached.audioUrl;

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
          final audioUrl = data[0]['mp3Url'] ?? data[0]['audioUrl'] ?? '';
          return audioUrl.toString();
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<void> preload() async {
    if (isIndexing.value) return;

    final incomplete = _ghazalMap.values.where((g) => !g.hasFullText).toList();
    if (isLoaded && incomplete.isEmpty) return;

    isIndexing.value = true;
    loadingProgress.value = 0;

    try {
      final list = await GhazalLocalService.instance.fetchGhazalsList();
      if (list.isEmpty) return;

      final Map<String, Ghazal> toSave = {};

      for (final g in list) {
        if (_ghazalMap.containsKey(g.id)) {
          final existing = _ghazalMap[g.id]!;
          if (!existing.hasFullText) {
            existing
              ..text = g.text
              ..hasFullText = true;
            toSave[existing.id] = existing;
          }
        } else {
          _ghazalMap[g.id] = g;
          toSave[g.id] = g;
        }
      }

      if (toSave.isNotEmpty) await _box.putAll(toSave);

      _rebuildSearchIndex();
      cachedGhazalsRx.assignAll(_ghazalMap.values.toList());
      textsReadyCount.value = _ghazalMap.values
          .where((g) => g.hasFullText)
          .length;
      loadingProgress.value = 1.0;
    } catch (e, st) {
      debugPrintStack(
        label: 'GhazalCacheService.preload error: $e',
        stackTrace: st,
      );
    } finally {
      isIndexing.value = false;
      loadingProgress.value = 1.0;
    }
  }

  Future<Ghazal> getGhazalDetail(String id) async {
    final cached = _ghazalMap[id];
    if (cached != null && cached.hasFullText) return cached;

    final g = await GhazalLocalService.instance.fetchGhazalById(id);
    _ghazalMap[id] = g;
    await _box.put(id, g);
    _updateIndexEntry(g);
    final idx = cachedGhazalsRx.indexWhere((e) => e.id == id);
    if (idx != -1) cachedGhazalsRx[idx] = g;
    return g;
  }

  List<Ghazal> search(String normalizedQuery) {
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

  List<String> randomExcerpts({int count = 5}) {
    final valid = _ghazalMap.values
        .where((g) => g.hasFullText && g.text.trim().isNotEmpty)
        .toList();
    if (valid.isEmpty) return [];

    final shuffled = List<Ghazal>.from(valid)..shuffle(Random());
    final result = <String>[];
    for (final g in shuffled) {
      final excerpt = _extractFirstFourBeyts(g.text);
      if (excerpt.isNotEmpty) {
        result.add(excerpt);
        if (result.length >= count) break;
      }
    }
    return result;
  }

  Ghazal? randomGhazal() {
    final valid = _ghazalMap.values.where((g) => g.hasFullText).toList();
    if (valid.isEmpty) return null;
    valid.shuffle(Random());
    return valid.first;
  }

  void _rebuildSearchIndex() {
    _searchIndex
      ..clear()
      ..addAll(_ghazalMap.values.map(_toIndexed));
  }

  void _updateIndexEntry(Ghazal g) {
    final idx = _searchIndex.indexWhere((e) => e.original.id == g.id);
    final entry = _toIndexed(g);
    if (idx != -1) {
      _searchIndex[idx] = entry;
    } else {
      _searchIndex.add(entry);
    }
  }

  _IndexedGhazal _toIndexed(Ghazal g) => _IndexedGhazal(
    original: g,
    normalizedTitle: _normalize(g.title),
    normalizedText: _normalize(g.text),
  );

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
      final m1 = lines[i];
      final m2 = (i + 1 < lines.length) ? lines[i + 1] : '';
      beyts.add(m2.isNotEmpty ? '$m1\n$m2' : m1);
    }
    return beyts.join('\n\n');
  }

  String _normalize(String text) => text
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}

class _IndexedGhazal {
  final Ghazal original;
  final String normalizedTitle;
  final String normalizedText;
  const _IndexedGhazal({
    required this.original,
    required this.normalizedTitle,
    required this.normalizedText,
  });
}
