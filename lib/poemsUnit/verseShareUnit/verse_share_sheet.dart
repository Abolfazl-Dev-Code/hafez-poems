import 'package:flutter/material.dart';

import 'image_share_preview.dart';
import 'share_branding.dart';
import 'share_image_capture_service.dart';
import 'share_type_sheet.dart';

Future<void> showVerseShareSheet(
  BuildContext context, {
  required String verseText,
  required String poemTitle,
}) async {
  final type = await showShareTypeSheet(context);

  if (!context.mounted || type == null) return;

  switch (type) {
    case VerseShareType.text:
      final buffer = StringBuffer();
      buffer.writeln(poemTitle);
      buffer.writeln();
      buffer.writeln(verseText.trim());
      buffer.writeln();
      buffer.writeln(ShareBranding.poetName);
      buffer.writeln(ShareBranding.downloadLink);

      await ShareImageCaptureService.shareText(buffer.toString());
      break;

    case VerseShareType.image:
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ImageSharePreview(verseText: verseText, poemTitle: poemTitle),
        ),
      );
      break;
  }
}
