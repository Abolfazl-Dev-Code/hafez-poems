import '../contracts/i_poem_storage.dart';

class DriftPoemStorage<T> implements IPoemStorage<T> {
  DriftPoemStorage({
    required this.category,
    required Future<Map<String, T>> Function() loadAll,
    required Future<void> Function(String id, T item) writeToDb,
    required Future<void> Function(Map<String, T> items) writeAllToDb,
  }) : _loadAllFromDb = loadAll,
       _writeToDb = writeToDb,
       _writeAllToDb = writeAllToDb;

  final String category;
  final Future<Map<String, T>> Function() _loadAllFromDb;
  final Future<void> Function(String id, T item) _writeToDb;
  final Future<void> Function(Map<String, T> items) _writeAllToDb;

  @override
  Future<void> open() async {}

  @override
  Future<Map<String, T>> readAll() => _loadAllFromDb();

  @override
  Future<void> put(String id, T item) => _writeToDb(id, item);

  @override
  Future<void> putAll(Map<String, T> items) => _writeAllToDb(items);

  @override
  Future<void> compact() async {}
}
