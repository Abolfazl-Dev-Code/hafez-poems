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

  final List<Widget> _pages = const [
    SettingPage(title: 'تنظیمات'),
    CollectionScreen(initialTab: 0, showTabs: false),
    HomeScreen(),
    CollectionScreen(initialTab: 1, showTabs: false),
    CollectionScreen(initialTab: 2, showTabs: false),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.darkIcon : Colors.white;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
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
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
