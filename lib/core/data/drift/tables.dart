import 'package:drift/drift.dart';

// ══════════════════════════════════════════════════════════
//  دامنه‌ی ۱: Poem Cache — یک جدول مشترک برای هر شش نوع شعر
// ══════════════════════════════════════════════════════════

class PoemCacheTable extends Table {
  TextColumn get poemId => text()();
  TextColumn get category =>
      text()(); // ghazal, ghataat, ghasayed, robaeyat, montasab, other
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text().withDefault(const Constant(''))();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();
  BoolColumn get hasFullText => boolean().withDefault(const Constant(false))();
  TextColumn get kind => text().nullable()();

  @override
  Set<Column> get primaryKey => {poemId, category};
}

// ══════════════════════════════════════════════════════════
//  دامنه‌ی ۲: User Actions
// ══════════════════════════════════════════════════════════

class LikedItemsTable extends Table {
  TextColumn get poemId => text()();
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text()();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {poemId};
}

class SavedItemsTable extends Table {
  TextColumn get poemId => text()();
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text()();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {poemId};
}

class HighlightItemsTable extends Table {
  TextColumn get itemKey => text()();
  TextColumn get poemId => text()();
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text()();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();
  TextColumn get highlightedLine => text()();
  IntColumn get lineIndex => integer()();
  IntColumn get colorValue => integer()();

  @override
  Set<Column> get primaryKey => {itemKey};
}

// ══════════════════════════════════════════════════════════
//  دامنه‌ی ۳: Read Status
// ══════════════════════════════════════════════════════════

class ReadPoemsTable extends Table {
  TextColumn get poemId => text()();
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {poemId};
}

// ══════════════════════════════════════════════════════════
//  دامنه‌ی ۴: Profile Settings
// ══════════════════════════════════════════════════════════
class SettingsTable extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}
