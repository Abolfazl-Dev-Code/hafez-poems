// lib/controllers/verse_sync_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hafez_poems/models/recitation_models.dart';
import 'package:hafez_poems/poemsUnit/verseSyncUnit/recitation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerseSyncController extends ChangeNotifier {
  bool _disposed = false;
  List<VerseSyncPoint> _syncPoints = [];
  int _activeVerseOrder = -1;
  bool _isLoadingSync = false;
  int get activeVerseOrder => _activeVerseOrder;
  bool get isLoadingSync => _isLoadingSync;
  bool get hasSyncData => _syncPoints.isNotEmpty;
  final _service = RecitationService();
  int _manualLeadMs = 800;
  int get manualLeadMs => _manualLeadMs;
  static const _prefKeyLead = 'verse_sync_manual_lead_ms';

  Future<void> loadManualLead() async {
    final prefs = await SharedPreferences.getInstance();
    _manualLeadMs = prefs.getInt(_prefKeyLead) ?? 0;
    _notify();
  }

  Future<void> setManualLead(int ms) async {
    _manualLeadMs = ms;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyLead, ms);
    _notify();
  }

  // ── بارگذاری زمان‌بندی ─────────────────────────────
  Future<void> loadSyncPoints(String xmlUrl) async {
    if (_disposed) return;
    _syncPoints = [];
    _activeVerseOrder = -1;
    _isLoadingSync = true;
    _notify();

    try {
      final points = await _service.fetchSyncPoints(xmlUrl);
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
  void updatePosition(Duration position) {
    if (_disposed || _syncPoints.isEmpty) return;

    final ms = position.inMilliseconds + _manualLeadMs;
    int newOrder = -1;

    for (final point in _syncPoints) {
      if (point.audioMilliseconds <= ms) {
        newOrder = point.verseOrder;
      } else {
        break;
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
