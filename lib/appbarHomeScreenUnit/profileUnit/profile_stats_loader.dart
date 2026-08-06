part of 'profile_controller.dart';

extension ProfileStatsLoader on ProfileController {
  void _loadData() {
    final likedItems = _likedStorage.values().reversed.toList();
    final savedItems = _savedStorage.values().reversed.toList();
    final highlightItems = _highlightStorage.values().reversed.toList();

    likedCount.value = likedItems.length;
    savedCount.value = savedItems.length;
    highlightedCount.value = highlightItems.length;
    likedRatio.value = ProfileController.totalGhazals > 0
        ? likedCount.value / ProfileController.totalGhazals
        : 0.0;
    savedRatio.value = ProfileController.totalGhazals > 0
        ? savedCount.value / ProfileController.totalGhazals
        : 0.0;
    readCount.value = _readStatus.count;
    readRatio.value = ProfileController.totalGhazals > 0
        ? readCount.value / ProfileController.totalGhazals
        : 0.0;

    recentLikedTitles.value = likedItems
        .map((e) => e.poemTitle.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentSavedTitles.value = savedItems
        .map((e) => e.poemTitle.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    recentHighlightTexts.value = highlightItems
        .map((e) => e.highlightedLine.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    mostReadTitle.value = _getMostRepeatedTitle([
      ...likedItems.map((e) => e.poemTitle.trim()),
      ...savedItems.map((e) => e.poemTitle.trim()),
      ...highlightItems.map((e) => e.poemTitle.trim()),
    ]);

    favoriteQuote.value = recentHighlightTexts.isNotEmpty
        ? recentHighlightTexts.first
        : 'هنوز برگزیده‌ی ثبت نشده است';
  }

  String _getMostRepeatedTitle(List<String> titles) {
    final clean = titles
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (clean.isEmpty) return '';

    final Map<String, int> freq = {};
    for (final t in clean) {
      freq[t] = (freq[t] ?? 0) + 1;
    }

    String best = '';
    int bestCount = 0;

    freq.forEach((k, v) {
      if (v > bestCount) {
        best = k;
        bestCount = v;
      }
    });

    return best;
  }
}
