// lib/services/recitation_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import '../models/recitation_models.dart';

class RecitationService {
  static const String _base = 'https://api.ganjoor.net';
  static const String _prefKeyPrefix = 'selected_recitation_';

  // ── دریافت لیست خوانندگان ─────────────────────────────

  /// لیست تمام خوانندگان موجود برای یک شعر
  /// endpoint: GET /api/ganjoor/poem/{id}/recitations
  // lib/services/recitation_service.dart
  Future<List<RecitationInfo>> fetchRecitations(String poemId) async {
    try {
      final url = Uri.parse('$_base/api/ganjoor/poem/$poemId/recitations');
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 12));

      debugPrint('📡 recitations status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          debugPrint(
            '📡 first recitation keys: ${(data.first as Map).keys.toList()}',
          );
          debugPrint('📡 first recitation: ${data.first}');
        }
        final list = data
            .map((e) => RecitationInfo.fromJson(e as Map<String, dynamic>))
            .where((r) => r.mp3Url.isNotEmpty)
            .toList();
        debugPrint('✅ parsed ${list.length} recitations');
        return list;
      }
      return [];
    } catch (e) {
      debugPrint('❌ fetchRecitations error ($poemId): $e');
      return [];
    }
  }

  // ── دریافت زمان‌بندی مصراع‌ها ─────────────────────────

  /// زمان‌بندی هر مصراع برای یک خواننده خاص
  /// endpoint: GET /api/ganjoor/poem/{id}/recitations/{recitationId}
  /// فیلد syncArray در پاسخ حاوی verseOrder و audioMiliseconds است
  Future<List<VerseSyncPoint>> fetchSyncPoints(String xmlUrl) async {
    if (xmlUrl.isEmpty) return [];
    try {
      debugPrint('📡 fetchSyncPoints URL: $xmlUrl');
      final response = await http
          .get(Uri.parse(xmlUrl), headers: {'Accept': 'application/xml'})
          .timeout(const Duration(seconds: 12));

      debugPrint('📡 syncPoints status: ${response.statusCode}');

      if (response.statusCode != 200) return [];

      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('SyncInfo');

      final points = items.map((node) {
        final order =
            int.tryParse(
              node.findElements('VerseOrder').firstOrNull?.innerText ?? '',
            ) ??
            0;
        final ms =
            int.tryParse(
              node.findElements('AudioMiliseconds').firstOrNull?.innerText ??
                  '',
            ) ??
            0;
        return VerseSyncPoint(verseOrder: order, audioMilliseconds: ms);
      }).toList();

      points.sort((a, b) => a.audioMilliseconds.compareTo(b.audioMilliseconds));

      debugPrint('✅ parsed ${points.length} sync points');
      return points;
    } catch (e) {
      debugPrint('❌ fetchSyncPoints error: $e');
      return [];
    }
  }

  // ── ذخیره و بازیابی انتخاب خواننده ───────────────────

  /// ذخیره انتخاب خواننده برای این شعر
  Future<void> saveSelectedRecitation(
    String poemId,
    RecitationInfo recitation,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_prefKeyPrefix}id_$poemId', recitation.id);
    await prefs.setString('${_prefKeyPrefix}url_$poemId', recitation.mp3Url);
    await prefs.setString(
      '${_prefKeyPrefix}artist_$poemId',
      recitation.audioArtist,
    );
  }

  /// بازیابی خواننده ذخیره‌شده برای این شعر
  Future<RecitationInfo?> loadSelectedRecitation(String poemId) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('${_prefKeyPrefix}id_$poemId');
    final url = prefs.getString('${_prefKeyPrefix}url_$poemId');
    final artist = prefs.getString('${_prefKeyPrefix}artist_$poemId');

    if (id == null || url == null || url.isEmpty) return null;
    return RecitationInfo(id: id, audioArtist: artist ?? 'نامشخص', mp3Url: url);
  }
}
