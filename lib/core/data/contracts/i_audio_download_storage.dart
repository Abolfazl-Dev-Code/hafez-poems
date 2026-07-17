import 'package:hafez_poems/core/data/drift/app_database.dart';

abstract class IAudioDownloadStorage {
  Future<DownloadedAudioRow?> getStatus(
    String poemId,
    String poemCategory,
    String reciterKey,
  );
  Stream<DownloadedAudioRow?> watchStatus(
    String poemId,
    String poemCategory,
    String reciterKey,
  );
  Stream<List<DownloadedAudioRow>> watchDownloadsForPoem(
    String poemId,
    String poemCategory,
  );
  Future<List<DownloadedAudioRow>> getDownloadsForPoem(
    String poemId,
    String poemCategory,
  );
  Future<List<DownloadedAudioRow>> getAllDownloaded();

  Future<void> upsertDownloading({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String reciterDisplayName,
    required String fileName,
    required String sourceUrl,
    int? sourceRecitationId,
  });

  Future<void> markDownloaded({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String localFilePath,
    required int fileSizeBytes,
    int? durationMs,
    String? checksum,
    String? syncXml,
  });

  Future<void> markError(String poemId, String poemCategory, String reciterKey);
  Future<void> delete(String poemId, String poemCategory, String reciterKey);
  Future<void> incrementPlayCount(
    String poemId,
    String poemCategory,
    String reciterKey,
  );

  Future<DefaultReciterRow?> getDefaultReciter(String scope);

  Future<void> setDefaultReciter({
    required String scope,
    required String reciterKey,
    required String reciterDisplayName,
  });
}
