part of 'poem_cache_services.dart';

class OtherPoemCacheService extends BasePoemCacheService<OtherPoemModel> {
  @override
  String get categoryLabel => 'اشعار دیگر';
  @override
  String idOf(OtherPoemModel o) => o.id;
  @override
  String titleOf(OtherPoemModel o) => o.title;
  @override
  String textOf(OtherPoemModel o) => o.text;
  @override
  bool hasFullTextOf(OtherPoemModel o) => o.hasFullText;
  @override
  void setFullText(OtherPoemModel o, String text) {
    o.text = text;
    o.hasFullText = true;
  }

  @override
  OtherPoemLocalService get localService => OtherPoemLocalService.instance;

  Future<OtherPoemModel> getOtherPoemDetail(String id) => getDetail(id);
  RxList<OtherPoemModel> get cachedOtherPoemsRx => cachedItemsRx;
}
