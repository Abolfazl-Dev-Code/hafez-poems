import 'package:flutter/material.dart';
import 'package:hafez_poems/collectionUnit/highlight_tab_widget.dart';
import 'package:hafez_poems/collectionUnit/liked_tab_widget.dart';
import 'package:hafez_poems/collectionUnit/saved_tab_widget.dart';

class CollectionScreen extends StatefulWidget {
  final int initialTab;
  final bool showTabs;

  const CollectionScreen({
    super.key,
    this.initialTab = 0,
    this.showTabs = true,
  });

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  static const List<String> _tabTitles = [
    'اشعار علاقه‌مندی‌‌شده',
    'اشعار ذخیره‌شده',
    'برگزیده‌‌ها',
  ];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (_tabController.index != _currentTab) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: widget.showTabs
            ? AppBar(
                title: Text(_tabTitles[_currentTab]), // ← title تب فعلی
                centerTitle: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.favorite_outline),
                      text: 'علاقه‌مندی‌‌ها',
                    ),
                    Tab(icon: Icon(Icons.bookmark_outline), text: 'ذخیره‌شده'),
                    Tab(icon: Icon(Icons.highlight), text: 'برگزیده‌‌ها'),
                  ],
                ),
              )
            : null,
        body: widget.showTabs
            ? IndexedStack(
                index: _currentTab,
                children: const [LikedTab(), SavedTab(), HighlightsTab()],
              )
            : switch (widget.initialTab) {
                0 => const LikedTab(),
                1 => const SavedTab(),
                _ => const HighlightsTab(),
              },
      ),
    );
  }
}
