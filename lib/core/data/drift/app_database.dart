import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PoemCacheTable,
    LikedItemsTable,
    SavedItemsTable,
    HighlightItemsTable,
    ReadPoemsTable,
    SettingsTable,
    DownloadedAudioTable,
    DefaultReciterTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(downloadedAudioTable);
        await m.createTable(defaultReciterTable);
      }
      if (from < 3) {
        await m.addColumn(
          downloadedAudioTable,
          downloadedAudioTable.poemCategory,
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'hafez_poems_db');
  }
}
