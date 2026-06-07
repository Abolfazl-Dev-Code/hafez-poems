import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/montasab_model.dart';

/// سرویس کاملاً آفلاین اشعار منتسب حافظ
class MontasabLocalService {
  static MontasabLocalService? _instance;
  static MontasabLocalService get instance =>
      _instance ??= MontasabLocalService._();
  MontasabLocalService._();

  List<MontasabModel> _montasab = [];
  Map<String, MontasabModel> _map = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/json/hafez_montasab.json');
    final list = jsonDecode(raw) as List;
    _montasab = list.map((e) {
      final m = e as Map<String, dynamic>;
      return MontasabModel.fromJson(m);
    }).toList();
    _map = {for (final m in _montasab) m.id: m};
    _loaded = true;
  }

  Future<List<MontasabModel>> fetchMontasabList() async {
    await _ensureLoaded();
    return _montasab;
  }

  Future<MontasabModel> fetchMontasabById(String id) async {
    await _ensureLoaded();
    final m = _map[id];
    if (m == null) throw Exception('شعر منتسب با id=$id یافت نشد');
    return m;
  }

  int get count => _montasab.length;
  bool get isLoaded => _loaded;
}
