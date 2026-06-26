import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/controllers/search_controller.dart' as app;
import 'package:hafez_poems/widgets/search_resualt_title.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<app.SearchController>();

    return Obx(() {
      if (c.searchText.value.isEmpty) {
        return const Center(child: Text('عبارتی برای جستجو وارد کنید'));
      }
      if (c.results.isEmpty) {
        return const Center(child: Text('نتیجه‌ای یافت نشد'));
      }
      return ListView.builder(
        itemCount: c.results.length,
        itemBuilder: (_, i) => SearchResultTitle(
          item: c.results[i],
          query: app.normalize(c.searchText.value), // ← normalize اضافه کن
        ),
      );
    });
  }
}
