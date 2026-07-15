import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/tables.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/audio_file_naming.dart';
import 'package:hafez_poems/poemsUnit/audioPoemsUnit/audioDownloadUnit/download_progress_info.dart';

class AudioDownloadManager extends ChangeNotifier {
  final IAudioDownloadStorage _repository;
  final Dio _dio = Dio();

  final Map<String, CancelToken> _activeTokens = {};
  final Map<String, DownloadProgressInfo> _progress = {};

  AudioDownloadManager(this._repository);

  String _keyOf(String poemId, String poemCategory, String reciterKey) =>
      '$poemId:$poemCategory:$reciterKey';

  DownloadProgressInfo? progressFor(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) {
    return _progress[_keyOf(poemId, poemCategory, reciterKey)];
  }

  bool isDownloading(String poemId, String poemCategory, String reciterKey) {
    return _activeTokens.containsKey(_keyOf(poemId, poemCategory, reciterKey));
  }

  Future<void> startDownload({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String reciterDisplayName,
    required String sourceUrl,
    required String fileNameCategory,
    required int fileNamePoemNumber,
    required String poetName,
    int? sourceRecitationId,
    String? syncXml,
  }) async {
    final key = _keyOf(poemId, poemCategory, reciterKey);
    if (_activeTokens.containsKey(key)) return;

    final existing = await _repository.getStatus(
      poemId,
      poemCategory,
      reciterKey,
    );
    if (existing != null && existing.status == DownloadStatus.downloaded) {
      return;
    }

    final fileName = AudioFileNaming.buildFileName(
      poemCategory: fileNameCategory,
      poemNumber: fileNamePoemNumber,
      poetName: poetName,
      audioArtist: reciterDisplayName,
    );

    final tempPath = await AudioFileNaming.tempPathFor(fileName);
    final finalPath = await AudioFileNaming.finalPathFor(fileName);
    final cancelToken = CancelToken();
    _activeTokens[key] = cancelToken;

    _progress[key] = const DownloadProgressInfo(
      received: 0,
      total: 0,
      status: DownloadStatus.downloading,
    );
    notifyListeners();

    await _repository.upsertDownloading(
      poemId: poemId,
      poemCategory: poemCategory,
      reciterKey: reciterKey,
      reciterDisplayName: reciterDisplayName,
      fileName: fileName,
      sourceUrl: sourceUrl,
      sourceRecitationId: sourceRecitationId,
    );

    try {
      await _dio.download(
        sourceUrl,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          _progress[key] = DownloadProgressInfo(
            received: received,
            total: total,
            status: DownloadStatus.downloading,
          );
          notifyListeners();
        },
      );

      final tempFile = File(tempPath);
      if (!await tempFile.exists()) {
        throw Exception('temp file missing after download');
      }

      final fileSize = await tempFile.length();
      final checksum = await _computeChecksum(tempFile);

      await tempFile.rename(finalPath);

      await _repository.markDownloaded(
        poemId: poemId,
        poemCategory: poemCategory,
        reciterKey: reciterKey,
        localFilePath: finalPath,
        fileSizeBytes: fileSize,
        checksum: checksum,
        syncXml: syncXml,
      );

      _progress[key] = DownloadProgressInfo(
        received: fileSize,
        total: fileSize,
        status: DownloadStatus.downloaded,
      );
    } on DioException catch (e) {
      await _cleanupTemp(tempPath);
      if (CancelToken.isCancel(e)) {
        _progress.remove(key);
        await _repository.delete(poemId, poemCategory, reciterKey);
      } else {
        _progress[key] = const DownloadProgressInfo(
          received: 0,
          total: 0,
          status: DownloadStatus.error,
        );
        await _repository.markError(poemId, poemCategory, reciterKey);
      }
    } catch (e) {
      await _cleanupTemp(tempPath);
      _progress[key] = const DownloadProgressInfo(
        received: 0,
        total: 0,
        status: DownloadStatus.error,
      );
      await _repository.markError(poemId, poemCategory, reciterKey);
    } finally {
      _activeTokens.remove(key);
      notifyListeners();
    }
  }

  void cancelDownload(String poemId, String poemCategory, String reciterKey) {
    final key = _keyOf(poemId, poemCategory, reciterKey);
    _activeTokens[key]?.cancel();
  }

  Future<void> retryDownload({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String reciterDisplayName,
    required String sourceUrl,
    required String fileNameCategory,
    required int fileNamePoemNumber,
    required String poetName,
    int? sourceRecitationId,
    String? syncXml,
  }) async {
    await startDownload(
      poemId: poemId,
      poemCategory: poemCategory,
      reciterKey: reciterKey,
      reciterDisplayName: reciterDisplayName,
      sourceUrl: sourceUrl,
      fileNameCategory: fileNameCategory,
      fileNamePoemNumber: fileNamePoemNumber,
      poetName: poetName,
      sourceRecitationId: sourceRecitationId,
      syncXml: syncXml,
    );
  }

  Future<void> deleteDownload(
    String poemId,
    String poemCategory,
    String reciterKey,
  ) async {
    final row = await _repository.getStatus(poemId, poemCategory, reciterKey);
    if (row != null && row.localFilePath.isNotEmpty) {
      final file = File(row.localFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await _repository.delete(poemId, poemCategory, reciterKey);
    _progress.remove(_keyOf(poemId, poemCategory, reciterKey));
    notifyListeners();
  }

  Future<String> _computeChecksum(File file) async {
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  Future<void> _cleanupTemp(String tempPath) async {
    final tempFile = File(tempPath);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  }
}
