import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/screens/collection_screen.dart';
import 'package:hafez_poems/screens/home_screen.dart';
import 'package:hafez_poems/screens/settings_screen.dart';
import 'package:hafez_poems/services/bottom_nav_bar_animation.dart';
import 'package:hafez_poems/theme/color_style.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

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

  static const List<IconData> _icons = [
    Icons.settings,
    Icons.favorite,
    Icons.home,
    Icons.bookmark,
    Icons.highlight,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // بدون bottomNavigationBar — نویگیشن بار داخل Stack روی body قرار می‌گیرد
      body: Stack(
        children: [
          // PageView تمام صفحه را پر می‌کند
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            reverse: false,
            children: _pages,
          ),

          // نویگیشن بار شناور روی محتوا
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _CurvedNavBar(
              currentIndex: _currentIndex,
              icons: _icons,
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

class _CurvedNavBar extends StatelessWidget {
  final int currentIndex;
  final List<IconData> icons;
  final List<String> labels;
  final Color barColor;
  final Color restingIconColor;
  final ValueChanged<int> onTap;

  static const double barHeight = 60;
  static const double circleSize = 52;
  static const double extraLift = 0;

  const _CurvedNavBar({
    required this.currentIndex,
    required this.icons,
    required this.labels,
    required this.barColor,
    required this.restingIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double s = 1 / icons.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double loc = currentIndex / icons.length;
        final double itemSpan = width / icons.length;

        return SizedBox(
          height: barHeight + extraLift,
          width: width,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: loc, end: loc),
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            builder: (context, animatedLoc, _) {
              final double circleCenterX = (animatedLoc + s / 2) * width;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(width, barHeight),
                      painter: BottomNavBarAnimation(
                        loc: animatedLoc,
                        s: s,
                        color: barColor,
                      ),
                    ),
                  ),

                  ...List.generate(icons.length, (index) {
                    if (index == currentIndex) return const SizedBox.shrink();
                    return Positioned(
                      bottom: 10,
                      left: itemSpan * index,
                      width: itemSpan,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onTap(index);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[index],
                              size: 23,
                              color: restingIconColor,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              labels[index],
                              style: TextStyle(
                                fontFamily: 'vazir',
                                fontSize: 11,
                                color: restingIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  Positioned(
                    bottom: barHeight - circleSize / 2,
                    left: circleCenterX - circleSize / 2,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: barColor,
                      ),
                      child: Center(
                        child: Icon(
                          icons[currentIndex],
                          size: 26,
                          color: restingIconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
