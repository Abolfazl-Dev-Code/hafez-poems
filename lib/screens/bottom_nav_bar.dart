import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/screens/collection_screen.dart';
import 'package:hafez_poems/screens/home_screen.dart';
import 'package:hafez_poems/screens/settings_screen.dart';
import 'package:hafez_poems/theme/color_style.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);
  final GlobalKey<CurvedNavigationBarState> _navBarKey = GlobalKey();

  final List<Widget> _pages = const [
    SettingPage(title: 'تنظیمات'),
    CollectionScreen(initialTab: 0, showTabs: false),
    HomeScreen(),
    CollectionScreen(initialTab: 1, showTabs: false),
    CollectionScreen(initialTab: 2, showTabs: false),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _navBarKey.currentState?.setPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.darkIcon : Colors.white;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        reverse: false,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navBarKey,
        index: _currentIndex,
        height: 60,
        animationCurve: Curves.linear,
        items: [
          Icon(Icons.settings, size: 30, color: iconColor),
          Icon(Icons.favorite, size: 30, color: iconColor),
          Icon(Icons.home, size: 30, color: iconColor),
          Icon(Icons.bookmark, size: 30, color: iconColor),
          Icon(Icons.highlight, size: 30, color: iconColor),
        ],
        color: AppColors.icon,
        buttonBackgroundColor: AppColors.icon,
        backgroundColor: theme.scaffoldBackgroundColor,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onNavTap,
      ),
    );
  }
}
