// lib/services/poem_local_services.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ghazal_model.dart';
import '../models/ghataat_model.dart';
import '../models/robaeyat_model.dart';
import '../models/montasab_model.dart';
import '../models/ghasayed_model.dart';
import '../models/other_poem_model.dart';

// ══════════════════════════════════════════════════════════
//  BASE
// ══════════════════════════════════════════════════════════

abstract class BasePoemLocalService<T> {
  List<T> _items = [];
  Map<String, T> _map = {};
  bool _loaded = false;

  String get assetPath;
  String idOf(T item);
  T fromJson(Map<String, dynamic> m);

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString(assetPath);
    final list = jsonDecode(raw) as List;
    _items = list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    _map = {for (final item in _items) idOf(item): item};
    _loaded = true;
  }

  Future<List<T>> fetchList() async {
    await _ensureLoaded();
    return _items;
  }

  Future<T> fetchById(String id) async {
    await _ensureLoaded();
    final item = _map[id];
    if (item == null) throw Exception('آیتم با id=$id یافت نشد');
    return item;
  }

  int get count => _items.length;
  bool get isLoaded => _loaded;
}

// ══════════════════════════════════════════════════════════
//  GHAZAL
// ══════════════════════════════════════════════════════════

class GhazalLocalService extends BasePoemLocalService<Ghazal> {
  static final instance = GhazalLocalService._();
  GhazalLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_ghazals.json';
  @override
  String idOf(Ghazal item) => item.id;

  @override
  Ghazal fromJson(Map<String, dynamic> m) => Ghazal(
    id: m['id'].toString(),
    title: m['title'].toString(),
    text: m['text'].toString(),
    hasFullText: true,
    audioUrl: '',
  );

  // متد اختصاصی غزل
  Future<Ghazal?> fetchRandomGhazal() async {
    await _ensureLoaded();
    if (_items.isEmpty) return null;
    _items.shuffle();
    return _items.first;
  }

  Future<List<Ghazal>> fetchGhazalsList() => fetchList();
  Future<Ghazal> fetchGhazalById(String id) => fetchById(id);
}

// ══════════════════════════════════════════════════════════
//  GHATAAT
// ══════════════════════════════════════════════════════════

class GhataatLocalService extends BasePoemLocalService<GhataatModel> {
  static final instance = GhataatLocalService._();
  GhataatLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_ghataat.json';
  @override
  String idOf(GhataatModel item) => item.id;

  @override
  GhataatModel fromJson(Map<String, dynamic> m) => GhataatModel(
    id: m['id'].toString(),
    title: m['title'].toString(),
    text: m['text'].toString(),
    hasFullText: true,
  );
  Future<List<GhataatModel>> fetchGhataatList() => fetchList();
  Future<GhataatModel> fetchGhataatById(String id) => fetchById(id);
}

// ══════════════════════════════════════════════════════════
//  ROBAEYAT
// ══════════════════════════════════════════════════════════

class RobaeyatLocalService extends BasePoemLocalService<RobaeyatModel> {
  static final instance = RobaeyatLocalService._();
  RobaeyatLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_robaee.json';
  @override
  String idOf(RobaeyatModel item) => item.id;

  @override
  RobaeyatModel fromJson(Map<String, dynamic> m) => RobaeyatModel.fromJson(m);

  Future<List<RobaeyatModel>> fetchRobaeyatList() => fetchList();
  Future<RobaeyatModel> fetchRobaeyatById(String id) => fetchById(id);
}

// ══════════════════════════════════════════════════════════
//  MONTASAB
// ══════════════════════════════════════════════════════════

class MontasabLocalService extends BasePoemLocalService<MontasabModel> {
  static final instance = MontasabLocalService._();
  MontasabLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_montasab.json';
  @override
  String idOf(MontasabModel item) => item.id;

  @override
  MontasabModel fromJson(Map<String, dynamic> m) => MontasabModel.fromJson(m);

  Future<List<MontasabModel>> fetchMontasabList() => fetchList();
  Future<MontasabModel> fetchMontasabById(String id) => fetchById(id);
}

// ══════════════════════════════════════════════════════════
//  GHASAYED
// ══════════════════════════════════════════════════════════

class GhasayedLocalService extends BasePoemLocalService<GhasayedModel> {
  static final instance = GhasayedLocalService._();
  GhasayedLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_qasaid.json';
  @override
  String idOf(GhasayedModel item) => item.id;

  @override
  GhasayedModel fromJson(Map<String, dynamic> m) => GhasayedModel(
    id: m['id'].toString(),
    title: m['title'].toString(),
    text: m['text'].toString(),
    hasFullText: true,
  );
  Future<List<GhasayedModel>> fetchQasaidList() => fetchList();
  Future<GhasayedModel> fetchQasaidById(String id) => fetchById(id);
}

// ══════════════════════════════════════════════════════════
//  OTHER POEMS (مثنوی + ساقی‌نامه)
// ══════════════════════════════════════════════════════════

class OtherPoemLocalService extends BasePoemLocalService<OtherPoemModel> {
  static final instance = OtherPoemLocalService._();
  OtherPoemLocalService._();

  @override
  String get assetPath => 'assets/json/hafez_other.json';
  @override
  String idOf(OtherPoemModel item) => item.id;

  @override
  OtherPoemModel fromJson(Map<String, dynamic> m) => OtherPoemModel.fromJson(m);

  Future<List<OtherPoemModel>> fetchOtherPoemsList() => fetchList();
  Future<OtherPoemModel> fetchOtherPoemById(String id) => fetchById(id);
}
