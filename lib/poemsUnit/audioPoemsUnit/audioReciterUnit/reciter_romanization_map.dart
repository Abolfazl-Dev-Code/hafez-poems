import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_key.dart';

const Map<String, String> reciterRomanizedNames = {
  'فریدون_فرح_اندوز': 'FereydounFarahAndouz',
  'شهرام_ناظری': 'ShahramNazeri',
};

String romanizedNameFor(String audioArtist) {
  final key = ReciterKey.from(audioArtist);
  return reciterRomanizedNames[key] ?? _fallbackSlug(audioArtist);
}

String _fallbackSlug(String audioArtist) {
  return audioArtist
      .trim()
      .replaceAll(RegExp(r'[\s\u200c]+'), '')
      .replaceAll(RegExp(r'[^\w]'), '');
}
