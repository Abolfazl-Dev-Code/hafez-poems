import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';

class UserActionsSaver {
  IKeyedItemStorage<LikedItem> get _likedStorage =>
      Get.find<IKeyedItemStorage<LikedItem>>();
  IKeyedItemStorage<SavedItem> get _savedStorage =>
      Get.find<IKeyedItemStorage<SavedItem>>();
  IKeyedItemStorage<HighlightItem> get _highlightStorage =>
      Get.find<IKeyedItemStorage<HighlightItem>>();

  bool isLiked(String poemId) => _likedStorage.containsKey(poemId);

  bool isSaved(String poemId) => _savedStorage.containsKey(poemId);

  Future<void> toggleLike({
    required String poemId,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
  }) async {
    if (isLiked(poemId)) {
      await _likedStorage.delete(poemId);
    } else {
      await _likedStorage.put(
        poemId,
        LikedItem(
          poemId: poemId,
          poemTitle: poemTitle,
          poemText: poemText,
          audioUrl: audioUrl,
        ),
      );
    }
  }

  Future<void> toggleSave({
    required String poemId,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
  }) async {
    if (isSaved(poemId)) {
      await _savedStorage.delete(poemId);
    } else {
      await _savedStorage.put(
        poemId,
        SavedItem(
          poemId: poemId,
          poemTitle: poemTitle,
          poemText: poemText,
          audioUrl: audioUrl,
        ),
      );
    }
  }

  static String highlightKey(String poemId, int lineIndex) {
    return '${poemId}_$lineIndex';
  }

  bool isLineHighlighted(String poemId, int lineIndex) {
    return _highlightStorage.containsKey(highlightKey(poemId, lineIndex));
  }

  Future<void> toggleHighlight({
    required String poemId,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
    required String highlightedLine,
    required int lineIndex,
    required Color color,
  }) async {
    final key = highlightKey(poemId, lineIndex);

    if (_highlightStorage.containsKey(key)) {
      await _highlightStorage.delete(key);
    } else {
      await _highlightStorage.put(
        key,
        HighlightItem(
          poemId: poemId,
          poemTitle: poemTitle,
          poemText: poemText,
          audioUrl: audioUrl,
          highlightedLine: highlightedLine,
          lineIndex: lineIndex,
          colorValue: color.toARGB32(),
        ),
      );
    }
  }

  List<int> getHighlightedLineIndexes(String poemId) {
    return _highlightStorage
        .values()
        .where((item) => item.poemId == poemId)
        .map((item) => item.lineIndex)
        .toList();
  }

  List<HighlightItem> getAllHighlights() => _highlightStorage.values();

  List<LikedItem> getAllLikedGhazals() => _likedStorage.values();

  List<SavedItem> getAllSavedGhazals() => _savedStorage.values();
}
