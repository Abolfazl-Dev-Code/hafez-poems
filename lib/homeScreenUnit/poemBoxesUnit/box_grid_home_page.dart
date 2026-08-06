import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/homeScreenUnit/poemBoxesUnit/action_item.dart';
import 'package:hafez_poems/homeScreenUnit/poemBoxesUnit/poem_box_items.dart';

class PoemBoxGridsHomePage extends StatelessWidget {
  const PoemBoxGridsHomePage(ThemeData theme, {super.key});

  void _showSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    final items = buildPoemBoxActionItems(context, _showSheet);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 0.0;
          final itemWidth = (constraints.maxWidth - gap * 2) / 3;

          Widget buildCell(ActionItem item) {
            return SizedBox(width: itemWidth, child: item);
          }

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCell(items[0]),
                  const SizedBox(width: gap),
                  buildCell(items[1]),
                  const SizedBox(width: gap),
                  buildCell(items[2]),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCell(items[3]),
                  const SizedBox(width: gap),
                  buildCell(items[4]),
                  const SizedBox(width: gap),
                  buildCell(items[5]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
