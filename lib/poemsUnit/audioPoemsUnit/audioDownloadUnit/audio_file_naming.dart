import 'dart:io';

import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioReciterUnit/reciter_romanization_map.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioFileNaming {
  AudioFileNaming._();

  static String buildFileName({
    required String poemCategory,
    required int poemNumber,
    required String poetName,
    required String audioArtist,
  }) {
    final safeReciter = romanizedNameFor(audioArtist);
    final safePoet = _sanitize(poetName);
    return '$poemCategory$poemNumber-$safePoet-$safeReciter.mp3';
  }

  static String _sanitize(String input) {
    return input.replaceAll(RegExp(r'[^\w\-]'), '');
  }

  static Future<Directory> audioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(appDir.path, 'hafez_audio'));
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  static Future<String> finalPathFor(String fileName) async {
    final dir = await audioDirectory();
    return p.join(dir.path, fileName);
  }

  static Future<String> tempPathFor(String fileName) async {
    final dir = await audioDirectory();
    final tempDir = Directory(p.join(dir.path, '.tmp'));
    if (!await tempDir.exists()) await tempDir.create(recursive: true);
    return p.join(tempDir.path, '$fileName.part');
  }
}
