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
  TextColumn get category => text()();
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text()();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {poemId, category};
}

class SavedItemsTable extends Table {
  TextColumn get poemId => text()();
  TextColumn get category => text()();
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text()();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {poemId, category};
}

class HighlightItemsTable extends Table {
  TextColumn get itemKey => text()();
  TextColumn get poemId => text()();
  TextColumn get category => text()();
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

// ══════════════════════════════════════════════════════════
//  دامنه‌ی 5: Audio Reciter Downloader
// ══════════════════════════════════════════════════════════
enum DownloadStatus { notDownloaded, downloading, downloaded, error }

@DataClassName('DownloadedAudioRow')
class DownloadedAudioTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get poemId => text()();
  TextColumn get poemCategory => text()();
  TextColumn get reciterKey => text()();
  TextColumn get reciterDisplayName => text()();
  IntColumn get sourceRecitationId => integer().nullable()();
  TextColumn get localFilePath => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get fileName => text()();
  TextColumn get syncXml => text().nullable()();
  IntColumn get fileSizeBytes => integer().withDefault(const Constant(0))();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get checksum => text().nullable()();
  DateTimeColumn get downloadedAt => dateTime().nullable()();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      textEnum<DownloadStatus>().withDefault(const Constant('notDownloaded'))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {poemId, poemCategory, reciterKey},
  ];
}

@DataClassName('DefaultReciterRow')
class DefaultReciterTable extends Table {
  TextColumn get scope => text()();
  TextColumn get reciterKey => text()();

  @override
  Set<Column> get primaryKey => {scope};
}
