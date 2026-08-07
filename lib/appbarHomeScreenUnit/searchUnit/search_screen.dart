import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_controller.dart'
    as app;
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_result.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_type_filter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final app.SearchController controller;
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = Get.find<app.SearchController>();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جستجوی اشعار')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: 'جستجو...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => controller.searchText.value = v,
              ),
              const SizedBox(height: 8),
              const SearchTypeFilter(),
              const SizedBox(height: 8),
              const Expanded(child: SearchResults()),
            ],
          ),
        ),
      ),
    );
  }
}
