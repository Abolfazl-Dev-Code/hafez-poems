abstract interface class IKeyedItemStorage<T> {
  bool containsKey(String key);
  T? get(String key);
  Future<void> put(String key, T value);
  Future<void> delete(String key);
  List<T> values();
  Stream<void> watch();
  Future<void> clear();
}
