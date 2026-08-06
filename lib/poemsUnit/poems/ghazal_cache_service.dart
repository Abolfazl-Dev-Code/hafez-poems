part of 'poem_cache_services.dart';

class GhazalCacheService extends BasePoemCacheService<Ghazal> {
  @override
  String get categoryLabel => 'غزل';
  @override
  String numberOf(Ghazal item) {
    final fromTitle = extractPoemNumber(titleOf(item));
    return fromTitle.isNotEmpty ? fromTitle : super.numberOf(item);
  }
  @override
  String idOf(Ghazal g) => g.id;
  @override
  String titleOf(Ghazal g) => g.title;
  @override
  String textOf(Ghazal g) => g.text;
  @override
  bool hasFullTextOf(Ghazal g) => g.hasFullText;
  @override
  void setFullText(Ghazal g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhazalLocalService get localService => GhazalLocalService.instance;

  final RxInt textsReadyCount = 0.obs;

  Future<void> updateAudioUrl(String id, String url) async {
    final ghazal = _map[id];
    if (ghazal != null) {
      ghazal.audioUrl = url;
      await _storage.put(id, ghazal);
      await _maybeCompact();
    }
  }

  @override
  Future<String> getAudioUrl(String id) async {
    final cached = _map[id];
    if (cached != null && cached.audioUrl.isNotEmpty) return cached.audioUrl;
    return super.getAudioUrl(id);
  }

  Ghazal? randomGhazal() {
    final valid = _map.values.where((g) => g.hasFullText).toList();
    if (valid.isEmpty) return null;
    return (valid..shuffle(Random())).first;
  }

  RxList<Ghazal> get cachedGhazalsRx => cachedItemsRx;
  List<Ghazal> get cachedGhazals => cachedItemsRx.toList();
  Future<Ghazal> getGhazalDetail(String id) => getDetail(id);
}
