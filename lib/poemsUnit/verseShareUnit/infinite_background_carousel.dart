import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

import 'verse_background_theme.dart';
import 'verse_share_card.dart';

class InfiniteBackgroundCarousel extends StatefulWidget {
  final String verseText;
  final String poemTitle;
  final List<GlobalKey> repaintKeys;
  final ValueChanged<int> onBackgroundChanged;

  const InfiniteBackgroundCarousel({
    super.key,
    required this.verseText,
    required this.poemTitle,
    required this.repaintKeys,
    required this.onBackgroundChanged,
  });

  @override
  State<InfiniteBackgroundCarousel> createState() =>
      _InfiniteBackgroundCarouselState();
}

class _InfiniteBackgroundCarouselState
    extends State<InfiniteBackgroundCarousel> {
  late final PageController _controller;

  int _selectedIndex = 0;

  int get _length => VerseBackgroundThemes.length;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onBackgroundChanged(0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: _length,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (page) {
        if (_selectedIndex == page) return;

        setState(() {
          _selectedIndex = page;
        });

        widget.onBackgroundChanged(page);
      },
      itemBuilder: (context, page) {
        final background = VerseBackgroundThemes.byIndex(page);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1080 / 1920,
              child: ClipRRect(
                borderRadius: AppRadius.xxlRadius,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 1080,
                    height: 1920,
                    child: VerseShareCard(
                      repaintKey: widget.repaintKeys[page],
                      verseText: widget.verseText,
                      poemTitle: widget.poemTitle,
                      background: background,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CarouselDots extends StatelessWidget {
  final int selectedIndex;

  const CarouselDots({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(VerseBackgroundThemes.length, (index) {
        final selected = selectedIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: selected ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: AppRadius.pillRadius,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        );
      }),
    );
  }
}
