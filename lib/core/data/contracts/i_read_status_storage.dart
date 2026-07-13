abstract interface class IReadStatusStorage {
  bool isRead(String id);
  Future<void> markAsRead(String id);
  int get count;
  Stream<void> watch();
}
