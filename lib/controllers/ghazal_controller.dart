import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import '../models/ghazal_model.dart';
import 'package:hafez_poems/services/api_services.dart';

class GhazalController extends GetxController {
  final GhazalCacheService _cache = Get.find<GhazalCacheService>();
  final ApiService _api = ApiService();

  List<Ghazal> get cachedGhazals => _cache.cachedGhazals.cast<Ghazal>();

  Ghazal? getCached(String id) {
    return cachedGhazals.firstWhereOrNull((g) => g.id == id);
  }

  String? getAudioUrl(String id) {
    final ghazal = getCached(id);
    return ghazal?.audioUrl;
  }

  Future<Ghazal> getGhazalWithAudio(String id) async {
    Ghazal ghazal = await _loadFromLocalJson(id);
    final cached = getCached(id);

    if (cached != null && cached.audioUrl.isNotEmpty) {
      ghazal.audioUrl = cached.audioUrl;
    } else {
      try {
        final onlineData = await _api.fetchGhazalById(id);

        if (onlineData.audioUrl.isNotEmpty) {
          ghazal.audioUrl = onlineData.audioUrl;
          await _cache.updateAudioUrl(id, ghazal.audioUrl);
        }
      } catch (e) {
        if (kDebugMode) {
          print("خطا در دریافت صدا از API: $e");
        }
      }
    }
    return ghazal;
  }

  Future<Ghazal> _loadFromLocalJson(String id) async {
    final String response = await rootBundle.loadString(
      'assets/json/hafez_ghazals.json',
    );
    final List<dynamic> data = json.decode(response);
    final item = data.firstWhereOrNull((g) => g['id'].toString() == id);

    if (item == null) {
      throw Exception("غزل با شناسه $id در فایل محلی پیدا نشد.");
    }
    return Ghazal.fromDetailJson(item);
  }
}
