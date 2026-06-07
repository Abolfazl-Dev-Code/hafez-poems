import 'dart:convert';
import 'package:flutter/services.dart';

class TabirService {
  static TabirService? _instance;
  static TabirService get instance => _instance ??= TabirService._();
  TabirService._();

  List<Map<String, dynamic>> _data = [];
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/hafez_tabir.json');
    final list = jsonDecode(raw) as List;
    _data = list.cast<Map<String, dynamic>>();
    _loaded = true;
  }

  Future<String?> findTabir(String plainText) async {
    await _ensureLoaded();
    if (_data.isEmpty || plainText.trim().isEmpty) return null;

    final lines = plainText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) return null;

    final firstLine = _normalize(lines.first);

    // جستجوی دقیق روی مصراع اول
    for (final entry in _data) {
      final norm = (entry['firstLineNorm'] as String? ?? '');
      if (norm == firstLine) {
        return entry['tabir'] as String?;
      }
    }

    for (final entry in _data) {
      final norm = (entry['firstLineNorm'] as String? ?? '');
      if (norm.isNotEmpty && firstLine.isNotEmpty) {
        if (_similarity(firstLine, norm) > 0.7) {
          return entry['tabir'] as String?;
        }
      }
    }

    return null;
  }

  String _normalize(String text) {
    text = text.replaceAll(RegExp(r'[\u064B-\u065F]'), '');
    text = text.replaceAll('\u064a', '\u06cc'); // ي → ی
    text = text.replaceAll('\u0643', '\u06a9'); // ك → ک
    text = text.replaceAll('\u0649', '\u06cc'); // ى → ی
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }

  double _similarity(String a, String b) {
    if (a == b) return 1.0;
    final shorter = a.length < b.length ? a : b;
    final longer = a.length < b.length ? b : a;
    if (longer.isEmpty) return 1.0;

    int matches = 0;
    for (int i = 0; i < shorter.length; i++) {
      if (i < longer.length && shorter[i] == longer[i]) matches++;
    }
    return matches / longer.length;
  }
}
