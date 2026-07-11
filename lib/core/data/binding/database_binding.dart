import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
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

class DatabaseBinding {
  static Future<void> init() async {
    final db = AppDatabase();
    Get.put<AppDatabase>(db, permanent: true);

    await _bindReadStatus(db);
    await _bindUserActions(db);
    await _bindProfileSettings(db);
    await _bindPoemCache(db);
  }

  static Future<void> _bindReadStatus(AppDatabase db) async {
    final storage = DriftReadStatusStorage(db);
    await storage.open();
    Get.put<IReadStatusStorage>(storage, permanent: true);
  }

  static Future<void> _bindUserActions(AppDatabase db) async {
    final liked = DriftKeyedItemStorage<LikedItem>(
      keyOf: (item) => item.poemId,
      loadAll: () async {
        final rows = await db.select(db.likedItemsTable).get();
        return rows
            .map(
              (r) => LikedItem(
                poemId: r.poemId,
                poemTitle: r.poemTitle,
                poemText: r.poemText,
                audioUrl: r.audioUrl,
              ),
            )
            .toList();
      },
      writeToDb: (key, value) => db
          .into(db.likedItemsTable)
          .insertOnConflictUpdate(
            LikedItemsTableCompanion.insert(
              poemId: key,
              poemTitle: value.poemTitle,
              poemText: value.poemText,
              audioUrl: Value(value.audioUrl),
            ),
          ),
      deleteFromDb: (key) => (db.delete(
        db.likedItemsTable,
      )..where((t) => t.poemId.equals(key))).go(),
      clearDb: () => db.delete(db.likedItemsTable).go(),
    );
    await liked.open();

    final saved = DriftKeyedItemStorage<SavedItem>(
      keyOf: (item) => item.poemId,
      loadAll: () async {
        final rows = await db.select(db.savedItemsTable).get();
        return rows
            .map(
              (r) => SavedItem(
                poemId: r.poemId,
                poemTitle: r.poemTitle,
                poemText: r.poemText,
                audioUrl: r.audioUrl,
              ),
            )
            .toList();
      },
      writeToDb: (key, value) => db
          .into(db.savedItemsTable)
          .insertOnConflictUpdate(
            SavedItemsTableCompanion.insert(
              poemId: key,
              poemTitle: value.poemTitle,
              poemText: value.poemText,
              audioUrl: Value(value.audioUrl),
            ),
          ),
      deleteFromDb: (key) => (db.delete(
        db.savedItemsTable,
      )..where((t) => t.poemId.equals(key))).go(),
      clearDb: () => db.delete(db.savedItemsTable).go(),
    );
    await saved.open();

    final highlighted = DriftKeyedItemStorage<HighlightItem>(
      keyOf: (item) => '${item.poemId}_${item.lineIndex}',
      loadAll: () async {
        final rows = await db.select(db.highlightItemsTable).get();
        return rows
            .map(
              (r) => HighlightItem(
                poemId: r.poemId,
                poemTitle: r.poemTitle,
                poemText: r.poemText,
                audioUrl: r.audioUrl,
                highlightedLine: r.highlightedLine,
                lineIndex: r.lineIndex,
                colorValue: r.colorValue,
              ),
            )
            .toList();
      },
      writeToDb: (key, value) => db
          .into(db.highlightItemsTable)
          .insertOnConflictUpdate(
            HighlightItemsTableCompanion.insert(
              itemKey: key,
              poemId: value.poemId,
              poemTitle: value.poemTitle,
              poemText: value.poemText,
              audioUrl: Value(value.audioUrl),
              highlightedLine: value.highlightedLine,
              lineIndex: value.lineIndex,
              colorValue: value.colorValue,
            ),
          ),
      deleteFromDb: (key) => (db.delete(
        db.highlightItemsTable,
      )..where((t) => t.itemKey.equals(key))).go(),
      clearDb: () => db.delete(db.highlightItemsTable).go(),
    );
    await highlighted.open();

    Get.put<IKeyedItemStorage<LikedItem>>(liked, permanent: true);
    Get.put<IKeyedItemStorage<SavedItem>>(saved, permanent: true);
    Get.put<IKeyedItemStorage<HighlightItem>>(highlighted, permanent: true);
  }

  static Future<void> _bindProfileSettings(AppDatabase db) async {
    final storage = DriftSettingsStorage(db);
    await storage.open();
    Get.put<ISettingsStorage>(storage, permanent: true);
  }

  static Future<void> _bindPoemCache(AppDatabase db) async {
    final ghazal = DriftPoemStorage<Ghazal>(
      category: 'ghazal',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('ghazal'))).get();
        return {
          for (final r in rows)
            r.poemId: Ghazal(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'ghazal',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'ghazal',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                ),
              )
              .toList(),
        );
      }),
    );
    await ghazal.open();

    final ghataat = DriftPoemStorage<GhataatModel>(
      category: 'ghataat',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('ghataat'))).get();
        return {
          for (final r in rows)
            r.poemId: GhataatModel(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'ghataat',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'ghataat',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                ),
              )
              .toList(),
        );
      }),
    );
    await ghataat.open();

    final ghasayed = DriftPoemStorage<GhasayedModel>(
      category: 'ghasayed',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('ghasayed'))).get();
        return {
          for (final r in rows)
            r.poemId: GhasayedModel(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'ghasayed',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'ghasayed',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                ),
              )
              .toList(),
        );
      }),
    );
    await ghasayed.open();

    final robaeyat = DriftPoemStorage<RobaeyatModel>(
      category: 'robaeyat',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('robaeyat'))).get();
        return {
          for (final r in rows)
            r.poemId: RobaeyatModel(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'robaeyat',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'robaeyat',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                ),
              )
              .toList(),
        );
      }),
    );
    await robaeyat.open();

    final montasab = DriftPoemStorage<MontasabModel>(
      category: 'montasab',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('montasab'))).get();
        return {
          for (final r in rows)
            r.poemId: MontasabModel(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'montasab',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'montasab',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                ),
              )
              .toList(),
        );
      }),
    );
    await montasab.open();

    final otherPoems = DriftPoemStorage<OtherPoemModel>(
      category: 'other',
      loadAll: () async {
        final rows = await (db.select(
          db.poemCacheTable,
        )..where((t) => t.category.equals('other'))).get();
        return {
          for (final r in rows)
            r.poemId: OtherPoemModel(
              id: r.poemId,
              title: r.poemTitle,
              text: r.poemText,
              audioUrl: r.audioUrl,
              hasFullText: r.hasFullText,
              kind: r.kind ?? '',
            ),
        };
      },
      writeToDb: (id, item) => db
          .into(db.poemCacheTable)
          .insertOnConflictUpdate(
            PoemCacheTableCompanion.insert(
              poemId: id,
              category: 'other',
              poemTitle: item.title,
              poemText: Value(item.text),
              audioUrl: Value(item.audioUrl),
              hasFullText: Value(item.hasFullText),
              kind: Value(item.kind),
            ),
          ),
      writeAllToDb: (items) => db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.poemCacheTable,
          items.entries
              .map(
                (e) => PoemCacheTableCompanion.insert(
                  poemId: e.key,
                  category: 'other',
                  poemTitle: e.value.title,
                  poemText: Value(e.value.text),
                  audioUrl: Value(e.value.audioUrl),
                  hasFullText: Value(e.value.hasFullText),
                  kind: Value(e.value.kind),
                ),
              )
              .toList(),
        );
      }),
    );
    await otherPoems.open();

    Get.put<IPoemStorage<Ghazal>>(ghazal, permanent: true);
    Get.put<IPoemStorage<GhataatModel>>(ghataat, permanent: true);
    Get.put<IPoemStorage<GhasayedModel>>(ghasayed, permanent: true);
    Get.put<IPoemStorage<RobaeyatModel>>(robaeyat, permanent: true);
    Get.put<IPoemStorage<MontasabModel>>(montasab, permanent: true);
    Get.put<IPoemStorage<OtherPoemModel>>(otherPoems, permanent: true);
  }
}
