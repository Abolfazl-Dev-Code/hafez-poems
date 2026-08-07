part of 'audio_player_controller.dart';

extension AudioPlayerRecitations on AudioPlayerController {
  Future<void> loadRecitations(String poemId, String poemCategory) async {
    if (_disposed) return;

    _isLoadingRecitations = true;
    _recitations = [];
    _notify();

    try {
      final saved = await _recitationService.loadSelectedRecitation(poemId);
      final list = await _recitationService.fetchRecitations(poemId);
      if (_disposed) return;

      _recitations = list;

      if (list.isNotEmpty) {
        if (saved != null && list.any((r) => r.id == saved.id)) {
          _selectedRecitation = list.firstWhere((r) => r.id == saved.id);
        } else {
          final globalDefault = await _storage.getDefaultReciter(poemCategory);
          RecitationInfo? bestMatch;

          if (globalDefault != null) {
            int bestScore = 0;

            for (final reciter in list) {
              final score = ReciterKey.score(
                reciter.audioArtist,
                globalDefault.reciterDisplayName,
              );

              if (score > bestScore) {
                bestScore = score;
                bestMatch = reciter;
              }
            }
          }

          _selectedRecitation = bestMatch ?? list.first;
        }
      } else {
        _selectedRecitation = null;
      }
    } finally {
      if (!_disposed) {
        _isLoadingRecitations = false;
        _notify();
      }
    }
  }

  Future<void> selectRecitation(
    String poemId,
    RecitationInfo recitation,
  ) async {
    if (_disposed) return;

    _selectedRecitation = recitation;
    _notify();

    await _recitationService.saveSelectedRecitation(poemId, recitation);

    await load(id: poemId, audioUrl: recitation.mp3Url, title: _lastTitle);
  }
}
