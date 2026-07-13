abstract interface class ISettingsStorage {
  T? get<T>(String key);
  T getOrDefault<T>(String key, T defaultValue);
  Future<void> put(String key, dynamic value);
  Future<void> delete(String key);
}
