part of 'database_binding.dart';

Future<void> _bindPoemCache(AppDatabase db) async {
  final ghazal = await _buildGhazalCache(db);
  final ghataat = await _buildGhataatCache(db);
  final ghasayed = await _buildGhasayedCache(db);
  final robaeyat = await _buildRobaeyatCache(db);
  final montasab = await _buildMontasabCache(db);
  final otherPoems = await _buildOtherPoemsCache(db);

  Get.put<IPoemStorage<Ghazal>>(ghazal, permanent: true);
  Get.put<IPoemStorage<GhataatModel>>(ghataat, permanent: true);
  Get.put<IPoemStorage<GhasayedModel>>(ghasayed, permanent: true);
  Get.put<IPoemStorage<RobaeyatModel>>(robaeyat, permanent: true);
  Get.put<IPoemStorage<MontasabModel>>(montasab, permanent: true);
  Get.put<IPoemStorage<OtherPoemModel>>(otherPoems, permanent: true);
}
