part of 'database_binding.dart';

Future<DriftPoemStorage<RobaeyatModel>> _buildRobaeyatCache(AppDatabase db) async {
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
  return robaeyat;
}

Future<DriftPoemStorage<MontasabModel>> _buildMontasabCache(AppDatabase db) async {
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
  return montasab;
}

Future<DriftPoemStorage<OtherPoemModel>> _buildOtherPoemsCache(AppDatabase db) async {
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
  return otherPoems;
}

