part of 'poem_cache_services.dart';

class MontasabCacheService extends BasePoemCacheService<MontasabModel> {
  @override
  String get categoryLabel => 'اشعار منتسب';
  @override
  bool get sortById => true;
  @override
  String idOf(MontasabModel m) => m.id;
  @override
  String titleOf(MontasabModel m) => m.title;
  @override
  String textOf(MontasabModel m) => m.text;
  @override
  bool hasFullTextOf(MontasabModel m) => m.hasFullText;
  @override
  void setFullText(MontasabModel m, String text) {
    m.text = text;
    m.hasFullText = true;
  }

  @override
  MontasabLocalService get localService => MontasabLocalService.instance;

  Future<MontasabModel> getMontasabDetail(String id) => getDetail(id);
  RxList<MontasabModel> get cachedMontasabRx => cachedItemsRx;
}
