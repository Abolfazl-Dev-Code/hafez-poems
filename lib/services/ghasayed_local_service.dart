import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ghasayed_model.dart';

/// سرویس کاملاً آفلاین قصاید حافظ
class GhasayedLocalService {
  static GhasayedLocalService? _instance;
  static GhasayedLocalService get instance =>
      _instance ??= GhasayedLocalService._();
  GhasayedLocalService._();

  List<GhasayedModel> _qasaid = [];
  Map<String, GhasayedModel> _map = {};
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/json/hafez_qasaid.json');
    final list = jsonDecode(raw) as List;
    _qasaid = list.map((e) {
      final m = e as Map<String, dynamic>;
      return GhasayedModel(
        id: m['id'].toString(),
        title: m['title'].toString(),
        text: m['text'].toString(),
        hasFullText: true,
      );
    }).toList();
    _map = {for (final g in _qasaid) g.id: g};
    _loaded = true;
  }

  Future<List<GhasayedModel>> fetchQasaidList() async {
    await _ensureLoaded();
    return _qasaid;
  }

  Future<GhasayedModel> fetchQasaidById(String id) async {
    await _ensureLoaded();
    final g = _map[id];
    if (g == null) throw Exception('قصیده با id=$id یافت نشد');
    return g;
  }

  int get count => _qasaid.length;
  bool get isLoaded => _loaded;
}
