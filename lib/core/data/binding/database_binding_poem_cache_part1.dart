part of 'database_binding.dart';

Future<DriftPoemStorage<Ghazal>> _buildGhazalCache(AppDatabase db) async {
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
  return ghazal;
}

Future<DriftPoemStorage<GhataatModel>> _buildGhataatCache(AppDatabase db) async {
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
  return ghataat;
}

Future<DriftPoemStorage<GhasayedModel>> _buildGhasayedCache(AppDatabase db) async {
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
  return ghasayed;
}

