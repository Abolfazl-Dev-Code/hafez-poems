import 'package:hafez_poems/theme/text_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'share_branding.dart';
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
          Container(decoration: background.overlayDecoration),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 130),
            child: Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: ClipRect(
                    child: Center(
                      child: AutoSizeText(
                        verseText.trim(),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        minFontSize: 22,
                        maxFontSize: 64,
                        maxLines: 20,
                        stepGranularity: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 64,
                          height: 1.9,
                          fontWeight: FontWeight.w700,
                          color: background.textColor,
                        ),
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
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 34,
                    color: background.titleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ShareBranding.poetName,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 26,
                    color: background.titleColor.withValues(alpha: 0.75),
                  ),
                ),
                const Spacer(),
                _BrandingFooter(background: background),
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

class _BrandingFooter extends StatelessWidget {
  final VerseBackgroundTheme background;

  const _BrandingFooter({required this.background});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 2,
          width: 160,
          color: background.textColor.withValues(alpha: 0.25),
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                ShareBranding.logoAsset,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(width: 72, height: 72);
                },
              ),
            ),
            const SizedBox(width: 24),
            Flexible(
              child: Text(
                ShareBranding.appName,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: background.textColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          ShareBranding.downloadLink,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 22,
            color: background.textColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
