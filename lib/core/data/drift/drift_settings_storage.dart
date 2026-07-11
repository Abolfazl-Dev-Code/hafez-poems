import 'dart:convert';
import '../contracts/i_settings_storage.dart';
import 'app_database.dart';

class DriftSettingsStorage implements ISettingsStorage {
  DriftSettingsStorage(this.db);

  final AppDatabase db;
  final Map<String, dynamic> _cache = {};

  Future<void> open() async {
    final rows = await db.select(db.settingsTable).get();
    _cache
      ..clear()
      ..addEntries(
        rows.map((r) => MapEntry(r.settingKey, jsonDecode(r.settingValue))),
      );
  }

  @override
  T? get<T>(String key) => _cache[key] as T?;

  @override
  T getOrDefault<T>(String key, T defaultValue) =>
      (_cache[key] as T?) ?? defaultValue;

  @override
  Future<void> put(String key, dynamic value) async {
    final encoded = jsonEncode(value);
    await db
        .into(db.settingsTable)
        .insertOnConflictUpdate(
          SettingsTableCompanion.insert(settingKey: key, settingValue: encoded),
        );
    _cache[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    await (db.delete(
      db.settingsTable,
    )..where((t) => t.settingKey.equals(key))).go();
    _cache.remove(key);
  }
}
