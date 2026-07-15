import 'dart:io';
import 'package:hafez_poems/core/data/contracts/i_audio_download_storage.dart';
import 'package:hafez_poems/core/data/drift/tables.dart';
import 'package:hafez_poems/core/utils/connectivity_checker.dart';

enum AudioSourceKind { local, remote, unavailable }

class AudioSourceResolution {
  final AudioSourceKind kind;
  final String path;
  final String? syncXml;
  final bool wasDownloadedButMissing;
  final String? userMessage;

  const AudioSourceResolution({
    required this.kind,
    this.path = '',
    this.syncXml,
    this.wasDownloadedButMissing = false,
    this.userMessage,
  });
}

class AudioSourceResolver {
  final IAudioDownloadStorage _storage;

  AudioSourceResolver(this._storage);

  Future<AudioSourceResolution> resolve({
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String onlineUrl,
  }) async {
    final row = await _storage.getStatus(poemId, poemCategory, reciterKey);

    if (row != null &&
        row.status == DownloadStatus.downloaded &&
        row.localFilePath.isNotEmpty) {
      final file = File(row.localFilePath);
      final exists = await file.exists();

      if (exists) {
        return AudioSourceResolution(
          kind: AudioSourceKind.local,
          path: row.localFilePath,
          syncXml: row.syncXml,
        );
      }

      await _storage.markError(poemId, poemCategory, reciterKey);

      final hasInternet = await ConnectivityChecker.hasInternet();
      if (hasInternet && onlineUrl.isNotEmpty) {
        return AudioSourceResolution(
          kind: AudioSourceKind.remote,
          path: onlineUrl,
          wasDownloadedButMissing: true,
          userMessage:
              'فایل دانلودشده روی حافظه پیدا نشد؛ نسخه‌ی آنلاین پخش می‌شود.',
        );
      }

      return const AudioSourceResolution(
        kind: AudioSourceKind.unavailable,
        wasDownloadedButMissing: true,
        userMessage:
            'فایل دانلودشده روی حافظه پیدا نشد و اینترنت هم در دسترس نیست.',
      );
    }

    if (onlineUrl.isEmpty) {
      return const AudioSourceResolution(
        kind: AudioSourceKind.unavailable,
        userMessage: 'فایل صوتی برای این شعر موجود نیست.',
      );
    }

    final hasInternet = await ConnectivityChecker.hasInternet();
    if (!hasInternet) {
      return const AudioSourceResolution(
        kind: AudioSourceKind.unavailable,
        userMessage:
            'این خواننده دانلود نشده و اینترنت در دسترس نیست. برای پخش، ابتدا به اینترنت وصل شوید یا صدا را از بخش خوانندگان دانلود کنید.',
      );
    }

    return AudioSourceResolution(kind: AudioSourceKind.remote, path: onlineUrl);
  }
}
