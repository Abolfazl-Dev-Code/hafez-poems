import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_icons_auto_play.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_chapter_data.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';

const _kGold = Color(0xFFD4AF37);
const _kCream = Color(0xFFF3ECD9);
const _kWine = Color(0xFF7A2436);

class ChapterCard extends StatelessWidget {
  final ChapterData data;
  final bool visible;
  final bool reverse;

  const ChapterCard({
    super.key,
    required this.data,
    required this.visible,
    required this.reverse,
  });

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[
      _buildIconBadge(),
      const SizedBox(width: 18),
      Expanded(child: _buildText()),
    ];

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 880),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.10),
        duration: const Duration(milliseconds: 880),
        curve: Curves.easeOutCubic,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reverse ? row.reversed.toList() : row,
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      width: 62,
      height: 62,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _kGold.withValues(alpha: 0.30)),
        gradient: RadialGradient(
          colors: [_kGold.withValues(alpha: 0.13), Colors.transparent],
        ),
      ),
      child: AutoPlayLucideIcon(
        icon: data.iconData,
        size: 28,
        color: Colors.white,
        duration: const Duration(seconds: 2),
        shouldPlay: visible,
      ),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.eyebrow,
          style: TextStyle(
            fontFamily: 'vazir',
            fontSize: 10,
            letterSpacing: 3.2,
            color: _kGold.withValues(alpha: 0.88),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          data.title,
          style: const TextStyle(
            fontFamily: 'vazir',
            fontSize: 21,
            color: _kCream,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          data.body,
          style: TextStyle(
            fontFamily: 'vazir',
            fontSize: 13.5,
            color: _kCream.withValues(alpha: 0.62),
            height: 2.1,
          ),
        ),

        if (data.pullQuote != null) ...[
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.fromLTRB(0, 14, 10, 14),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: _kWine, width: 3)),
              color: Color(0x1A7A2436),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.pullQuote!
                  .split('\n')
                  .map(
                    (line) => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontFamily: 'vazir',
                          fontSize: 14,
                          color: Color(0xFFF1D9B8),
                          height: 2.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5, top: 7),
            child: Text('غزل شماره 46'.toPersianNumbers()),
          ),
        ],
      ],
    );
  }
}
