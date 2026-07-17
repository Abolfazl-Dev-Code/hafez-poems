import 'package:flutter/foundation.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';

class DefaultReciterController extends ChangeNotifier {
  final IAudioDownloadStorage _storage;
  final Map<String, DefaultReciterRow?> _cache = {};
  final Map<String, Future<void>> _loading = {};

  DefaultReciterController(this._storage);

  DefaultReciterRow? defaultFor(String scope) => _cache[scope];

  Future<void> ensureLoaded(String scope) {
    if (_cache.containsKey(scope)) return Future.value();
    return _loading.putIfAbsent(scope, () async {
      final key = await _storage.getDefaultReciter(scope);
      _cache[scope] = key;
      notifyListeners();
    });
  }

  Future<void> setDefault(
    String scope,
    String reciterKey,
    String reciterDisplayName,
  ) async {
    await _storage.setDefaultReciter(
      scope: scope,
      reciterKey: reciterKey,
      reciterDisplayName: reciterDisplayName,
    );

    _cache[scope] = DefaultReciterRow(
      scope: scope,
      reciterKey: reciterKey,
      reciterDisplayName: reciterDisplayName,
    );

    notifyListeners();
  }
}
