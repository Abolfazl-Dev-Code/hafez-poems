import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';

/// سرویس کاملاً آفلاین رباعیات حافظ
class RobaeyatLocalService {
  static RobaeyatLocalService? _instance;
  static RobaeyatLocalService get instance =>
      _instance ??= RobaeyatLocalService._();
  RobaeyatLocalService._();

  List<RobaeyatModel> _robaeyat = [];
  Map<String, RobaeyatModel> _map = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/json/hafez_robaee.json');
    final list = jsonDecode(raw) as List;
    _robaeyat = list.map((e) {
      final m = e as Map<String, dynamic>;
      return RobaeyatModel.fromJson(m);
    }).toList();
    _map = {for (final r in _robaeyat) r.id: r};
    _loaded = true;
  }

  Future<List<RobaeyatModel>> fetchRobaeyatList() async {
    await _ensureLoaded();
    return _robaeyat;
  }

  Future<RobaeyatModel> fetchRobaeyatById(String id) async {
    await _ensureLoaded();
    final r = _map[id];
    if (r == null) throw Exception('رباعی با id=$id یافت نشد');
    return r;
  }

  int get count => _robaeyat.length;
  bool get isLoaded => _loaded;
}
