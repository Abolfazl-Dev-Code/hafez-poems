import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'verse_background_theme.dart';

class VerseShareCard extends StatelessWidget {
  final GlobalKey? repaintKey;
  final String verseText;
  final String poemTitle;
  final VerseBackgroundTheme background;

  const VerseShareCard({
    super.key,
    this.repaintKey,
    required this.verseText,
    required this.poemTitle,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: 1080,
      height: 1920,
      decoration: background.decoration,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black.withValues(alpha: 0.18)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 150),
            child: Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Center(
                    child: AutoSizeText(
                      verseText.trim(),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      minFontSize: 34,
                      maxFontSize: 64,
                      maxLines: 12,
                      stepGranularity: 1,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 64,
                        height: 1.9,
                        fontWeight: FontWeight.w700,
                        color: background.textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Text(
                  poemTitle,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: background.textColor.withValues(alpha: 0.75),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );

    if (repaintKey != null) {
      return RepaintBoundary(key: repaintKey, child: card);
    }

    return card;
  }
}
