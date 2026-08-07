import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_download_repository.dart';
import '../contracts/i_read_status_storage.dart';
import '../contracts/i_keyed_item_storage.dart';
import '../contracts/i_settings_storage.dart';
import '../contracts/i_poem_storage.dart';
import '../drift/app_database.dart';
import '../drift/drift_read_status_storage.dart';
import '../drift/drift_keyed_item_storage.dart';
import '../drift/drift_settings_storage.dart';
import '../drift/drift_poem_storage.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/ghazal_model.dart';
import 'package:hafez_poems/models/ghataat_model.dart';
import 'package:hafez_poems/models/ghasayed_model.dart';
import 'package:hafez_poems/models/robaeyat_model.dart';
import 'package:hafez_poems/models/montasab_model.dart';
import 'package:hafez_poems/models/other_poem_model.dart';

part 'database_binding_user_actions.dart';
part 'database_binding_poem_cache.dart';
part 'database_binding_poem_cache_part1.dart';
part 'database_binding_poem_cache_part2.dart';

class DatabaseBinding {
  static Future<void> init() async {
    final db = AppDatabase();
    Get.put<AppDatabase>(db, permanent: true);

    await _bindReadStatus(db);
    await _bindUserActions(db);
    await _bindProfileSettings(db);
    await _bindPoemCache(db);
    await _bindAudioDownloads(db);
  }

  static Future<void> _bindAudioDownloads(AppDatabase db) async {
    final repository = AudioDownloadRepository(db);
    Get.put<IAudioDownloadStorage>(repository, permanent: true);
  }

  static Future<void> _bindReadStatus(AppDatabase db) async {
    final storage = DriftReadStatusStorage(db);
    await storage.open();
    Get.put<IReadStatusStorage>(storage, permanent: true);
  }

  static Future<void> _bindProfileSettings(AppDatabase db) async {
    final storage = DriftSettingsStorage(db);
    await storage.open();
    Get.put<ISettingsStorage>(storage, permanent: true);
  }
}
