import 'dart:async';
import '../contracts/i_keyed_item_storage.dart';

class DriftKeyedItemStorage<T> implements IKeyedItemStorage<T> {
  DriftKeyedItemStorage({
    required this.keyOf,
    required Future<List<T>> Function() loadAll,
    required this._writeToDb,
    required this._deleteFromDb,
    required this._clearDb,
  }) : _loadAllFromDb = loadAll;

  final String Function(T item) keyOf;
  final Future<List<T>> Function() _loadAllFromDb;
  final Future<void> Function(String key, T value) _writeToDb;
  final Future<void> Function(String key) _deleteFromDb;
  final Future<void> Function() _clearDb;

  final Map<String, T> _cache = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  Future<void> open() async {
    final all = await _loadAllFromDb();
    _cache
      ..clear()
      ..addEntries(all.map((e) => MapEntry(keyOf(e), e)));
  }

  @override
  bool containsKey(String key) => _cache.containsKey(key);

  @override
  T? get(String key) => _cache[key];

  @override
  Future<void> put(String key, T value) async {
    await _writeToDb(key, value);
    _cache[key] = value;
    _changes.add(null);
  }

  @override
  Future<void> delete(String key) async {
    await _deleteFromDb(key);
    _cache.remove(key);
    _changes.add(null);
  }

  @override
  List<T> values() => _cache.values.toList();

  @override
  Stream<void> watch() => _changes.stream;

  @override
  Future<void> clear() async {
    await _clearDb();
    _cache.clear();
    _changes.add(null);
  }
}
