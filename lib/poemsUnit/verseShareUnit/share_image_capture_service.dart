import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareImageCaptureService {
  const ShareImageCaptureService._();

  static Future<Uint8List> capture(
    GlobalKey repaintKey, {
    double pixelRatio = 3,
    ValueChanged<double>? onProgress,
  }) async {
    onProgress?.call(0.05);

    await Future.delayed(const Duration(milliseconds: 20));

    final boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    onProgress?.call(0.20);

    final image = await boundary.toImage(pixelRatio: pixelRatio);

    onProgress?.call(0.55);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    onProgress?.call(0.80);

    return byteData!.buffer.asUint8List();
  }

  static Future<File> save(
    Uint8List bytes, {
    ValueChanged<double>? onProgress,
  }) async {
    onProgress?.call(0.85);

    final directory = await getTemporaryDirectory();

    final file = File(
      '${directory.path}/verse_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    await file.writeAsBytes(bytes, flush: true);

    onProgress?.call(0.95);

    return file;
  }

  static Future<void> shareImage(
    GlobalKey repaintKey, {
    ValueChanged<double>? onProgress,
  }) async {
    onProgress?.call(0.0);

    final bytes = await capture(repaintKey, onProgress: onProgress);

    final file = await save(bytes, onProgress: onProgress);

    onProgress?.call(1.0);

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }
}
