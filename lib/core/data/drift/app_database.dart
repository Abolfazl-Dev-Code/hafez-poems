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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'hafez_poems_db');
  }
}
