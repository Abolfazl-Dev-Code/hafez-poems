part of 'database_binding.dart';

Future<void> _bindUserActions(AppDatabase db) async {
  final liked = DriftKeyedItemStorage<LikedItem>(
    keyOf: (item) => '${item.poemId}|${item.category}',
    loadAll: () async {
      final rows = await db.select(db.likedItemsTable).get();
      return rows
          .map(
            (r) => LikedItem(
              poemId: r.poemId,
              category: r.category,
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
            poemId: value.poemId,
            category: value.category,
            poemTitle: value.poemTitle,
            poemText: value.poemText,
            audioUrl: Value(value.audioUrl),
          ),
        ),
    deleteFromDb: (key) {
      final parts = key.split('|');
      return (db.delete(db.likedItemsTable)..where(
            (t) => t.poemId.equals(parts[0]) & t.category.equals(parts[1]),
          ))
          .go();
    },
    clearDb: () => db.delete(db.likedItemsTable).go(),
  );
  await liked.open();

  final saved = DriftKeyedItemStorage<SavedItem>(
    keyOf: (item) => '${item.poemId}|${item.category}',
    loadAll: () async {
      final rows = await db.select(db.savedItemsTable).get();
      return rows
          .map(
            (r) => SavedItem(
              poemId: r.poemId,
              category: r.category,
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
            poemId: value.poemId,
            category: value.category,
            poemTitle: value.poemTitle,
            poemText: value.poemText,
            audioUrl: Value(value.audioUrl),
          ),
        ),
    deleteFromDb: (key) {
      final parts = key.split('|');
      return (db.delete(db.savedItemsTable)..where(
            (t) => t.poemId.equals(parts[0]) & t.category.equals(parts[1]),
          ))
          .go();
    },
    clearDb: () => db.delete(db.savedItemsTable).go(),
  );
  await saved.open();

  final highlighted = DriftKeyedItemStorage<HighlightItem>(
    keyOf: (item) => '${item.poemId}|${item.category}|${item.lineIndex}',
    loadAll: () async {
      final rows = await db.select(db.highlightItemsTable).get();
      return rows
          .map(
            (r) => HighlightItem(
              poemId: r.poemId,
              category: r.category,
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
            category: value.category,
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
