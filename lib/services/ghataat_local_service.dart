import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ghataat_model.dart';

/// سرویس کاملاً آفلاین قطعات حافظ
class GhataatLocalService {
  static GhataatLocalService? _instance;
  static GhataatLocalService get instance =>
      _instance ??= GhataatLocalService._();
  GhataatLocalService._();

  List<GhataatModel> _ghataat = [];
  Map<String, GhataatModel> _map = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/json/hafez_ghataat.json');
    final list = jsonDecode(raw) as List;
    _ghataat = list.map((e) {
      final m = e as Map<String, dynamic>;
      return GhataatModel(
        id: m['id'].toString(),
        title: m['title'].toString(),
        text: m['text'].toString(),
        hasFullText: true,
      );
    }).toList();
    _map = {for (final g in _ghataat) g.id: g};
    _loaded = true;
  }

  Future<List<GhataatModel>> fetchGhataatList() async {
    await _ensureLoaded();
    return _ghataat;
  }

  Future<GhataatModel> fetchGhataatById(String id) async {
    await _ensureLoaded();
    final g = _map[id];
    if (g == null) throw Exception('قطعه با id=$id یافت نشد');
    return g;
  }

  int get count => _ghataat.length;
  bool get isLoaded => _loaded;
}
