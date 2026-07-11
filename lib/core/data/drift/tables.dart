// lib/core/data/drift/tables.dart
//
// تعریف جدول‌های Drift برای هر ۴ دامنه. این فایل معادل SQL دقیق طراحی‌ای
// است که قبلاً روی کاغذ تأیید شد.

import 'package:drift/drift.dart';

// ══════════════════════════════════════════════════════════
//  دامنه‌ی ۱: Poem Cache — یک جدول مشترک برای هر شش نوع شعر
// ══════════════════════════════════════════════════════════
//
// چرا یک جدول مشترک (نه شش جدول جدا): اگر فردا بخواهیم فیلدی مثل
// «معنی/ترجمه» اضافه کنیم، فقط یک‌بار این جدول را migrate می‌کنیم، نه
// شش‌بار. ستون `category` مشخص می‌کند این ردیف مال کدام نوع شعر است.
class PoemCacheTable extends Table {
  TextColumn get poemId => text()();
  TextColumn get category => text()(); // ghazal, ghataat, ghasayed, robaeyat, montasab, other
  TextColumn get poemTitle => text()();
  TextColumn get poemText => text().withDefault(const Constant(''))();
  TextColumn get audioUrl => text().withDefault(const Constant(''))();
  BoolColumn get hasFullText => boolean().withDefault(const Constant(false))();
  // فقط برای category='other' پر می‌شود: 'masnavi' یا 'saghiname'
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
  // کلید ترکیبی: poemId_lineIndex — همان چیزی که
  // UserActionsSaver.highlightKey تولید می‌کند.
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
//
// مقدار همیشه JSON-encode شده ذخیره می‌شود، چون ستون SQL نمی‌تواند نوع
// پویا (رشته/عدد/لیست) را مستقیم نگه دارد. این جزئیات فقط داخل
// DriftSettingsStorage دیده می‌شود، نه بیرون از آن.
class SettingsTable extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}
