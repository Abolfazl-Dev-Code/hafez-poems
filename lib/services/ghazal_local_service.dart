import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ghazal_model.dart';

/// سرویس کاملاً آفلاین غزل‌های حافظ
class GhazalLocalService {
  static GhazalLocalService? _instance;
  static GhazalLocalService get instance =>
      _instance ??= GhazalLocalService._();
  GhazalLocalService._();

  List<Ghazal> _ghazals = [];
  Map<String, Ghazal> _map = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/json/hafez_ghazals.json');
    final list = jsonDecode(raw) as List;
    _ghazals = list.map((e) {
      final m = e as Map<String, dynamic>;
      return Ghazal(
        id: m['id'].toString(),
        title: m['title'].toString(),
        text: m['text'].toString(),
        hasFullText: true,
        audioUrl: '',
      );
    }).toList();
    _map = {for (final g in _ghazals) g.id: g};
    _loaded = true;
  }

  Future<List<Ghazal>> fetchGhazalsList() async {
    await _ensureLoaded();
    return _ghazals;
  }

  Future<Ghazal> fetchGhazalById(String id) async {
    await _ensureLoaded();
    final g = _map[id];
    if (g == null) throw Exception('غزل با id=$id یافت نشد');
    return g;
  }

  Future<Ghazal?> fetchRandomGhazal() async {
    await _ensureLoaded();
    if (_ghazals.isEmpty) return null;
    _ghazals.shuffle();
    return _ghazals.first;
  }

  int get count => _ghazals.length;
  bool get isLoaded => _loaded;
}
