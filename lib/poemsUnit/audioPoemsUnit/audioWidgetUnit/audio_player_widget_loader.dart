part of 'audio_player_widget.dart';

extension _AudioPlayerWidgetLoader on AudioPlayerWidgetState {
  Future<void> _loadSyncForSelectedRecitation() async {
    final recitation = widget.controller.selectedRecitation;
    if (recitation == null || recitation.xmlText.isEmpty) return;
    await widget.verseSyncController?.loadSyncPoints(recitation.xmlText);
  }

  Future<void> _loadIfNeeded() async {
    final ctrl = widget.controller;
    if (_initialized &&
        ctrl.lastId == widget.id &&
        ctrl.lastAudioUrl == widget.audioUrl) {
      return;
    }

    await ctrl.loadRecitations(widget.id, widget.category);

    final storage = Get.find<IAudioDownloadStorage>();
    final resolver = Get.find<AudioSourceResolver>();

    String? reciterKey;
    String onlineUrl = '';

    if (ctrl.selectedRecitation != null) {
      reciterKey = ReciterKey.from(ctrl.selectedRecitation!.audioArtist);
      onlineUrl = ctrl.selectedRecitation!.mp3Url;
    } else {
      final downloaded = await storage.getDownloadsForPoem(
        widget.id,
        widget.category,
      );
      if (downloaded.isNotEmpty) {
        final defaultReciter = await storage.getDefaultReciter(widget.category);
        final match = downloaded.firstWhere(
          (d) => d.reciterKey == defaultReciter?.reciterKey,
          orElse: () => downloaded.first,
        );
        reciterKey = match.reciterKey;
        onlineUrl = match.sourceUrl;
      }
    }

    if (reciterKey == null) {
      await ctrl.load(
        id: widget.id,
        audioUrl: widget.audioUrl,
        title: widget.title,
        fetchAudioUrl: widget.fetchAudioUrl,
      );
      await _loadSyncForSelectedRecitation();
      return;
    }

    _initialized = true;

    await ctrl.loadWithSourceResolution(
      id: widget.id,
      poemCategory: widget.category,
      reciterKey: reciterKey,
      onlineUrl: onlineUrl,
      resolver: resolver,
      title: widget.title,
      onSyncXmlResolved: (xml) {
        widget.verseSyncController?.loadSyncPoints(xml);
      },
      onSyncUnavailable: () {
        widget.verseSyncController?.clearSyncPoints();
      },
    );

    // Online streams don't carry sync XML in the resolver; load from recitation metadata.
    await _loadSyncForSelectedRecitation();
  }
}
