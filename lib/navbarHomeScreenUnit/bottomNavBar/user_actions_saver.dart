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

  static String _likeSaveKey(String poemId, String category) =>
      '$poemId|$category';

  bool isLiked(String poemId, String category) =>
      _likedStorage.containsKey(_likeSaveKey(poemId, category));

  bool isSaved(String poemId, String category) =>
      _savedStorage.containsKey(_likeSaveKey(poemId, category));

  Future<void> toggleLike({
    required String poemId,
    required String category,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
  }) async {
    final key = _likeSaveKey(poemId, category);
    if (isLiked(poemId, category)) {
      await _likedStorage.delete(key);
    } else {
      await _likedStorage.put(
        key,
        LikedItem(
          poemId: poemId,
          category: category,
          poemTitle: poemTitle,
          poemText: poemText,
          audioUrl: audioUrl,
        ),
      );
    }
  }

  Future<void> toggleSave({
    required String poemId,
    required String category,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
  }) async {
    final key = _likeSaveKey(poemId, category);
    if (isSaved(poemId, category)) {
      await _savedStorage.delete(key);
    } else {
      await _savedStorage.put(
        key,
        SavedItem(
          poemId: poemId,
          category: category,
          poemTitle: poemTitle,
          poemText: poemText,
          audioUrl: audioUrl,
        ),
      );
    }
  }

  static String highlightKey(String poemId, String category, int lineIndex) {
    return '$poemId|$category|$lineIndex';
  }

  bool isLineHighlighted(String poemId, String category, int lineIndex) {
    return _highlightStorage.containsKey(
      highlightKey(poemId, category, lineIndex),
    );
  }

  Future<void> toggleHighlight({
    required String poemId,
    required String category,
    required String poemTitle,
    required String poemText,
    required String audioUrl,
    required String highlightedLine,
    required int lineIndex,
    required Color color,
  }) async {
    final key = highlightKey(poemId, category, lineIndex);

    if (_highlightStorage.containsKey(key)) {
      await _highlightStorage.delete(key);
    } else {
      await _highlightStorage.put(
        key,
        HighlightItem(
          poemId: poemId,
          category: category,
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

  List<int> getHighlightedLineIndexes(String poemId, String category) {
    return _highlightStorage
        .values()
        .where((item) => item.poemId == poemId && item.category == category)
        .map((item) => item.lineIndex)
        .toList();
  }

  List<HighlightItem> getAllHighlights() => _highlightStorage.values();

  List<LikedItem> getAllLikedGhazals() => _likedStorage.values();

  List<SavedItem> getAllSavedGhazals() => _savedStorage.values();
}
