import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/collectionUnit/collection_screen.dart';
import 'package:hafez_poems/homeScreenUnit/home_screen.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/bottom_nav_bar_animation.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/settings_screen.dart';
import 'package:hafez_poems/theme/animated_app_icons.dart';
import 'package:hafez_poems/theme/app_icons.dart';
import 'package:hafez_poems/theme/color_style.dart';

part 'curved_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  static const double _navBarSideMargin = 16;
  static const double _navBarBottomMargin = 12;

  final List<Widget> _pages = const [
    SettingPage(title: 'تنظیمات'),
    CollectionScreen(initialTab: 0, showTabs: false),
    HomeScreen(),
    CollectionScreen(initialTab: 1, showTabs: false),
    CollectionScreen(initialTab: 2, showTabs: false),
  ];

  static const List<String> _titles = [
    'تنظیمات',
    'علاقه‌مندی',
    'خانه',
    'ذخیره‌‌‌ها',
    'برگزیده',
  ];

  static const List<String> _icons = [
    AppIcons.settings,
    AppIcons.like,
    AppIcons.home,
    AppIcons.saved,
    AppIcons.highlight,
  ];

  static const List<double> _iconStrokeWidths = [
    10, // settings
    14, // like
    16, // home
    8, // saved
    12, // highlight
  ];

  static const List<double> _iconScales = [
    1.3, // settings
    1.4, // like
    1.3, // home
    1.3, // saved
    3.1, // highlight
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    AppSnackBarService.dismiss();
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    AppSnackBarService.dismiss();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            reverse: false,
            children: _pages,
          ),
          Positioned(
            bottom: _navBarBottomMargin,
            left: _navBarSideMargin,
            right: _navBarSideMargin,
            child: _CurvedNavBar(
              currentIndex: _currentIndex,
              icons: _icons,
              iconScales: _iconScales,
              iconStrokeWidths: _iconStrokeWidths,
              labels: _titles,
              barColor: AppColors.icon,
              restingIconColor: isDark ? AppColors.darkIcon : Colors.white,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}
