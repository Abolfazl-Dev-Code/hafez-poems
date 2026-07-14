import 'package:drift/drift.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/app_database.dart';
import 'package:hafez_poems/core/data/drift/tables.dart';

class AudioDownloadRepository implements IAudioDownloadStorage {
  final AppDatabase _db;

  AudioDownloadRepository(this._db);

  @override
  Future<DownloadedAudioRow?> getStatus(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) {
    return (_db.select(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .getSingleOrNull();
  }

  @override
  Stream<DownloadedAudioRow?> watchStatus(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) {
    return (_db.select(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .watchSingleOrNull();
  }

  @override
  Future<List<DownloadedAudioRow>> getAllDownloaded() {
    return (_db.select(
      _db.downloadedAudioTable,
    )..where((t) => t.status.equals(DownloadStatus.downloaded.name))).get();
  }

  @override
  Future<void> upsertDownloading({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String reciterDisplayName,
    required String fileName,
    required String sourceUrl,
    int? sourceRecitationId,
  }) {
    return _db
        .into(_db.downloadedAudioTable)
        .insertOnConflictUpdate(
          DownloadedAudioTableCompanion.insert(
            poemId: poemId,
            poemCategory: poemCategory,
            reciterKey: reciterKey,
            reciterDisplayName: reciterDisplayName,
            fileName: fileName,
            sourceUrl: sourceUrl,
            localFilePath: '',
            sourceRecitationId: Value(sourceRecitationId),
            status: const Value(DownloadStatus.downloading),
          ),
        );
  }

  @override
  Future<void> markDownloaded({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String localFilePath,
    required int fileSizeBytes,
    int? durationMs,
    String? checksum,
  }) {
    return (_db.update(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .write(
          DownloadedAudioTableCompanion(
            localFilePath: Value(localFilePath),
            fileSizeBytes: Value(fileSizeBytes),
            durationMs: Value(durationMs),
            checksum: Value(checksum),
            status: const Value(DownloadStatus.downloaded),
            downloadedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> markError(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) {
    return (_db.update(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .write(
          const DownloadedAudioTableCompanion(
            status: Value(DownloadStatus.error),
          ),
        );
  }

  @override
  Future<void> delete(String poemId, String poemCategory, String reciterKey) {
    return (_db.delete(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .go();
  }

  @override
  Future<void> incrementPlayCount(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) async {
    final row = await getStatus(poemId, poemCategory, reciterKey);
    if (row == null) return;

    await (_db.update(_db.downloadedAudioTable)..where(
          (t) =>
              t.poemId.equals(poemId) &
              t.poemCategory.equals(poemCategory) &
              t.reciterKey.equals(reciterKey),
        ))
        .write(
          DownloadedAudioTableCompanion(
            playCount: Value(row.playCount + 1),
            lastPlayedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<String?> getDefaultReciter(String scope) async {
    final row = await (_db.select(
      _db.defaultReciterTable,
    )..where((t) => t.scope.equals(scope))).getSingleOrNull();
    return row?.reciterKey;
  }

  @override
  Future<void> setDefaultReciter(String scope, String reciterKey) {
    return _db
        .into(_db.defaultReciterTable)
        .insertOnConflictUpdate(
          DefaultReciterTableCompanion.insert(
            scope: scope,
            reciterKey: reciterKey,
          ),
        );
  }
}
