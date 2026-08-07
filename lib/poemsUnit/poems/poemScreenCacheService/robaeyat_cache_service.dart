part of 'poem_cache_services.dart';

class RobaeyatCacheService extends BasePoemCacheService<RobaeyatModel> {
  @override
  String get categoryLabel => 'رباعی';
  @override
  bool get sortById => true;
  @override
  String idOf(RobaeyatModel r) => r.id;
  @override
  String titleOf(RobaeyatModel r) => r.title;
  @override
  String textOf(RobaeyatModel r) => r.text;
  @override
  bool hasFullTextOf(RobaeyatModel r) => r.hasFullText;
  @override
  void setFullText(RobaeyatModel r, String text) {
    r.text = text;
    r.hasFullText = true;
  }

  @override
  RobaeyatLocalService get localService => RobaeyatLocalService.instance;

  Future<RobaeyatModel> getRobaeyatDetail(String id) => getDetail(id);
  RxList<RobaeyatModel> get cachedRobaeyatRx => cachedItemsRx;
}
