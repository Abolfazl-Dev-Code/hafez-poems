// lib/controllers/verse_sync_controller.dart
//
// مسئولیت: با توجه به position جاری پلیر، تعیین می‌کند کدام مصراع باید
// هایلایت شود. این controller از AudioPlayerController مستقل است و
// فقط به position و syncPoints نیاز دارد.

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/recitation_models.dart';
import '../services/recitation_service.dart';

class VerseSyncController extends ChangeNotifier {
  bool _disposed = false;

  List<VerseSyncPoint> _syncPoints = [];
  int _activeVerseOrder = -1; // verseOrder فعال (از API)
  bool _isLoadingSync = false;

  int get activeVerseOrder => _activeVerseOrder;
  bool get isLoadingSync => _isLoadingSync;
  bool get hasSyncData => _syncPoints.isNotEmpty;

  final _service = RecitationService();

  // ── بارگذاری زمان‌بندی ─────────────────────────────

  /// باید بعد از انتخاب خواننده فراخوانی شود
  Future<void> loadSyncPoints(String xmlUrl) async {
    // ← int recitationId حذف شد
    if (_disposed) return;
    _syncPoints = [];
    _activeVerseOrder = -1;
    _isLoadingSync = true;
    _notify();

    try {
      final points = await _service.fetchSyncPoints(xmlUrl); // ← xmlUrl
      if (_disposed) return;
      _syncPoints = points;
    } catch (e) {
      debugPrint('❌ loadSyncPoints error: $e');
    } finally {
      if (!_disposed) {
        _isLoadingSync = false;
        _notify();
      }
    }
  }

  void clearSyncPoints() {
    _syncPoints = [];
    _activeVerseOrder = -1;
    _notify();
  }

  // ── به‌روزرسانی بر اساس position ──────────────────

  /// با هر تغییر position پلیر باید فراخوانی شود
  void updatePosition(Duration position) {
    if (_disposed || _syncPoints.isEmpty) return;

    final ms = position.inMilliseconds;
    int newOrder = -1;

    // پیدا کردن آخرین sync point که زمانش از position کمتر یا مساوی است
    for (final point in _syncPoints) {
      if (point.audioMilliseconds <= ms) {
        newOrder = point.verseOrder;
      } else {
        break; // چون مرتب شده‌اند، بعدی‌ها بزرگ‌ترند
      }
    }

    if (newOrder != _activeVerseOrder) {
      _activeVerseOrder = newOrder;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
