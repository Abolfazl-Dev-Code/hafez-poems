part of 'poem_cache_services.dart';

class GhasayedCacheService extends BasePoemCacheService<GhasayedModel> {
  @override
  String get categoryLabel => 'قصیده';
  @override
  bool get sortById => true;
  @override
  String idOf(GhasayedModel g) => g.id;
  @override
  String titleOf(GhasayedModel g) => g.title;
  @override
  String textOf(GhasayedModel g) => g.text;
  @override
  bool hasFullTextOf(GhasayedModel g) => g.hasFullText;
  @override
  void setFullText(GhasayedModel g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhasayedLocalService get localService => GhasayedLocalService.instance;

  RxList<GhasayedModel> get cachedQasaidRx => cachedItemsRx;
  RxList<GhasayedModel> get cachedGhasayedRx => cachedItemsRx;
  Future<GhasayedModel> getQasaidDetail(String id) => getDetail(id);
  Future<GhasayedModel> getGhasayedDetail(String id) => getDetail(id);
}
