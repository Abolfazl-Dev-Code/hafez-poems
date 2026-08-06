part of 'poem_cache_services.dart';

class GhataatCacheService extends BasePoemCacheService<GhataatModel> {
  @override
  String get categoryLabel => 'قطعه';
  @override
  int get audioIndex => 1;
  @override
  String idOf(GhataatModel g) => g.id;
  @override
  String titleOf(GhataatModel g) => g.title;
  @override
  String textOf(GhataatModel g) => g.text;
  @override
  bool hasFullTextOf(GhataatModel g) => g.hasFullText;
  @override
  void setFullText(GhataatModel g, String text) {
    g.text = text;
    g.hasFullText = true;
  }

  @override
  GhataatLocalService get localService => GhataatLocalService.instance;

  Future<GhataatModel> getGhataatDetail(String id) => getDetail(id);
  RxList<GhataatModel> get cachedGhataatRx => cachedItemsRx;
}
