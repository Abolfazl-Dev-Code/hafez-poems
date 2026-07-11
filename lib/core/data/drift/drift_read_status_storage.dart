import 'dart:async';
import 'package:drift/drift.dart';
import '../contracts/i_read_status_storage.dart';
import 'app_database.dart';

class DriftReadStatusStorage implements IReadStatusStorage {
  DriftReadStatusStorage(this.db);

  final AppDatabase db;
  final Set<String> _cache = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  Future<void> open() async {
    final rows = await db.select(db.readPoemsTable).get();
    _cache
      ..clear()
      ..addAll(rows.map((r) => r.poemId));
  }

  @override
  bool isRead(String id) => _cache.contains(id);

  @override
  Future<void> markAsRead(String id) async {
    if (_cache.contains(id)) return;
    await db
        .into(db.readPoemsTable)
        .insertOnConflictUpdate(
          ReadPoemsTableCompanion.insert(
            poemId: id,
            readAt: Value(DateTime.now()),
          ),
        );
    _cache.add(id);
    _changes.add(null);
  }

  @override
  int get count => _cache.length;

  @override
  Stream<void> watch() => _changes.stream;
}
