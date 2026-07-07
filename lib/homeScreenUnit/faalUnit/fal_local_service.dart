import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class FalLocalService {
  static FalLocalService? _instance;
  static FalLocalService get instance => _instance ??= FalLocalService._();
  FalLocalService._();

  List<Map<String, dynamic>> _data = [];
  bool _loaded = false;
  final Random _random = Random();

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/json/hafez_fal.json');
      final list = jsonDecode(raw) as List;
      _data = list.cast<Map<String, dynamic>>();
      _loaded = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<FalLocalModel> getRandomFal() async {
    await _ensureLoaded();
    if (_data.isEmpty) throw Exception('داده‌های فال بارگذاری نشد');
    final entry = _data[_random.nextInt(_data.length)];
    return FalLocalModel.fromJson(entry);
  }

  Future<int> get count async {
    await _ensureLoaded();
    return _data.length;
  }
}

class FalLocalModel {
  final int id;
  final String title;
  final String poem;
  final String tabir;

  const FalLocalModel({
    required this.id,
    required this.title,
    required this.poem,
    required this.tabir,
  });

  factory FalLocalModel.fromJson(Map<String, dynamic> json) => FalLocalModel(
    id: (json['id'] as num).toInt(),
    title: (json['title'] ?? '').toString(),
    poem: (json['poem'] ?? '').toString(),
    tabir: (json['tabir'] ?? '').toString(),
  );

  List<String> get lines =>
      poem.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
}
