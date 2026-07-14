class ReciterKey {
  ReciterKey._();

  static String from(String audioArtist) {
    return audioArtist.trim().replaceAll(RegExp(r'[\s\u200c]+'), '_');
  }
}
