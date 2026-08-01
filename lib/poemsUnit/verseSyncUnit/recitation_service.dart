// lib/services/recitation_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hafez_poems/core/security/trusted_media_host.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class RecitationService {
  static const String _base = 'https://api.ganjoor.net';
  static const String _prefKeyPrefix = 'selected_recitation_';

  // ── دریافت لیست خوانندگان ─────────────────────────────
  Future<List<RecitationInfo>> fetchRecitations(String poemId) async {
    try {
      final url = Uri.parse('$_base/api/ganjoor/poem/$poemId/recitations');
      final response = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 12));

      if (kDebugMode) {
        debugPrint('📡 recitations status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final list = data
            .map((e) => RecitationInfo.fromJson(e as Map<String, dynamic>))
            .where((r) => r.mp3Url.isNotEmpty && isTrustedMediaUrl(r.mp3Url))
            .toList();
        if (kDebugMode) {
          debugPrint('✅ parsed ${list.length} recitations');
        }
        return list;
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ fetchRecitations error ($poemId): $e');
      }
      return [];
    }
  }

  // ── دریافت زمان‌بندی مصراع‌ها ─────────────────────────
  Future<List<VerseSyncPoint>> fetchSyncPoints(String xmlUrl) async {
    if (xmlUrl.isEmpty || !isTrustedMediaUrl(xmlUrl)) return [];
    try {
      final response = await http
          .get(Uri.parse(xmlUrl), headers: {'Accept': 'application/xml'})
          .timeout(const Duration(seconds: 12));

      if (kDebugMode) {
        debugPrint('📡 syncPoints status: ${response.statusCode}');
      }

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

      if (kDebugMode) {
        debugPrint('✅ parsed ${points.length} sync points');
      }
      return points;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ fetchSyncPoints error: $e');
      }
      return [];
    }
  }

  // ── ذخیره و بازیابی انتخاب خواننده ───────────────────
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

  Future<RecitationInfo?> loadSelectedRecitation(String poemId) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('${_prefKeyPrefix}id_$poemId');
    final url = prefs.getString('${_prefKeyPrefix}url_$poemId');
    final artist = prefs.getString('${_prefKeyPrefix}artist_$poemId');

    if (id == null || url == null || url.isEmpty) return null;
    return RecitationInfo(id: id, audioArtist: artist ?? 'نامشخص', mp3Url: url);
  }
}
