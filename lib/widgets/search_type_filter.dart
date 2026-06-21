import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/controllers/search_controller.dart' as app;

class SearchTypeFilter extends StatelessWidget {
  const SearchTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<app.SearchController>();
    final colorScheme = Theme.of(context).colorScheme;

    final types = [
      (null, 'همه'),
      (SearchResultType.ghazal, 'غزل'),
      (SearchResultType.ghataat, 'قطعه'),
      (SearchResultType.qasaid, 'قصیده'),
      (SearchResultType.robaeyat, 'رباعی'),
      (SearchResultType.montasab, 'منتسب'),
    ];

    return SizedBox(
      height: 34,
      child: Obx(() {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: types.map((t) {
            final selected = c.selectedType.value == t.$1;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () {
                  c.selectedType.value = t.$1;
                  c.performSearch();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.$2,
                    style: TextStyle(
                      color: selected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
