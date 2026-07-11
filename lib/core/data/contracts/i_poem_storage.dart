abstract interface class IPoemStorage<T> {
  Future<void> open();
  Future<Map<String, T>> readAll();
  Future<void> put(String id, T item);
  Future<void> putAll(Map<String, T> items);
  Future<void> compact();
}
