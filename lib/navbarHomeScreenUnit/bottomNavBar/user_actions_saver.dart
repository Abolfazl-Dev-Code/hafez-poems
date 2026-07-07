import 'package:flutter/material.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hive/hive.dart';

class UserActionsSaver {
  static const String likedBoxName = 'liked_ghazals';
  static const String savedBoxName = 'saved_ghazals';
  static const String highlightBoxName = 'highlighted_lines';

  Box<LikedItem> get _likedBox => Hive.box<LikedItem>(likedBoxName);

  Box<SavedItem> get _savedBox => Hive.box<SavedItem>(savedBoxName);

  Box<HighlightItem> get _highlightBox =>
      Hive.box<HighlightItem>(highlightBoxName);

  bool isLiked(String ghazalId) {
    return _likedBox.containsKey(ghazalId);
  }

  bool isSaved(String ghazalId) {
    return _savedBox.containsKey(ghazalId);
  }

  Future<void> toggleLike({
    required String ghazalId,
    required String title,
    required String text,
    required String audioUrl,
  }) async {
    if (isLiked(ghazalId)) {
      await _likedBox.delete(ghazalId);
    } else {
      await _likedBox.put(
        ghazalId,
        LikedItem(id: ghazalId, title: title, text: text, audioUrl: audioUrl),
      );
    }
  }

  Future<void> toggleSave({
    required String ghazalId,
    required String title,
    required String text,
    required String audioUrl,
  }) async {
    if (isSaved(ghazalId)) {
      await _savedBox.delete(ghazalId);
    } else {
      await _savedBox.put(
        ghazalId,
        SavedItem(id: ghazalId, title: title, text: text, audioUrl: audioUrl),
      );
    }
  }

  String _highlightKey(String ghazalId, int lineIndex) {
    return '${ghazalId}_$lineIndex';
  }

  bool isLineHighlighted(String ghazalId, int lineIndex) {
    return _highlightBox.containsKey(_highlightKey(ghazalId, lineIndex));
  }

  Future<void> toggleHighlight({
    required String ghazalId,
    required String ghazalTitle,
    required String ghazalText,
    required String audioUrl,
    required String highlightedLine,
    required int lineIndex,
    required Color color,
  }) async {
    final key = _highlightKey(ghazalId, lineIndex);

    if (_highlightBox.containsKey(key)) {
      await _highlightBox.delete(key);
    } else {
      await _highlightBox.put(
        key,
        HighlightItem(
          ghazalId: ghazalId,
          ghazalTitle: ghazalTitle,
          ghazalText: ghazalText,
          audioUrl: audioUrl,
          highlightedLine: highlightedLine,
          lineIndex: lineIndex,
          colorValue: color.toARGB32(),
        ),
      );
    }
  }

  List<int> getHighlightedLineIndexes(String ghazalId) {
    return _highlightBox.values
        .where((item) => item.ghazalId == ghazalId)
        .map((item) => item.lineIndex)
        .toList();
  }

  List<HighlightItem> getAllHighlights() {
    return _highlightBox.values.toList();
  }

  List<LikedItem> getAllLikedGhazals() {
    return _likedBox.values.toList();
  }

  List<SavedItem> getAllSavedGhazals() {
    return _savedBox.values.toList();
  }
}
