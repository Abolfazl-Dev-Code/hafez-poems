import 'package:flutter/material.dart';
import 'package:hafez_poems/widgets/biography_screen_chapter_card.dart';

class StoryBiography extends StatelessWidget {
  final List chapters;
  final List<GlobalKey> chapterKeys;
  final List<bool> chapterVisible;

  const StoryBiography({
    super.key,
    required this.chapters,
    required this.chapterKeys,
    required this.chapterVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 48, 22, 0),
      child: Column(
        children: List.generate(chapters.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 56),
            child: ChapterCard(
              key: chapterKeys[i],
              data: chapters[i],
              visible: chapterVisible[i],
              reverse: i.isOdd,
            ),
          );
        }),
      ),
    );
  }
}
