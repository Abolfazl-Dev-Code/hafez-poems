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
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
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

class _CurvedNavBar extends StatefulWidget {
  final int currentIndex;
  final List<String> icons;
  final List<double>? iconScales;
  final List<String> labels;
  final Color barColor;
  final Color restingIconColor;
  final ValueChanged<int> onTap;
  final List<double>? iconStrokeWidths;
  static const double barHeight = 60;
  static const double circleSize = 52;
  static const double borderRadius = barHeight / 2;

  const _CurvedNavBar({
    required this.currentIndex,
    required this.icons,
    this.iconScales,
    required this.labels,
    required this.barColor,
    required this.restingIconColor,
    required this.onTap,
    this.iconStrokeWidths,
  });

  @override
  State<_CurvedNavBar> createState() => _CurvedNavBarState();
}

class _CurvedNavBarState extends State<_CurvedNavBar> {
  late double _loc;
  double? _previousLoc;

  double _locFor(int index) => index / widget.icons.length;

  @override
  void initState() {
    super.initState();
    _loc = _locFor(widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant _CurvedNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousLoc = _loc;
      _loc = _locFor(widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double s = 1 / widget.icons.length;
    final double beginLoc = _previousLoc ?? _loc;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double itemSpan = width / widget.icons.length;

        return SizedBox(
          height: _CurvedNavBar.barHeight + _CurvedNavBar.circleSize / 2,
          width: width,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: beginLoc, end: _loc),
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            builder: (context, animatedLoc, _) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        _CurvedNavBar.borderRadius,
                      ),
                      child: CustomPaint(
                        size: Size(width, _CurvedNavBar.barHeight),
                        painter: BottomNavBarAnimation(
                          loc: animatedLoc,
                          s: s,
                          color: widget.barColor,
                        ),
                      ),
                    ),
                  ),

                  ...List.generate(widget.icons.length, (index) {
                    final bool isSelected = index == widget.currentIndex;
                    final double scale =
                        widget.iconScales != null &&
                            index < widget.iconScales!.length
                        ? widget.iconScales![index]
                        : 1.0;
                    final double? strokeWidth =
                        widget.iconStrokeWidths != null &&
                            index < widget.iconStrokeWidths!.length
                        ? widget.iconStrokeWidths![index]
                        : null;
                    return Positioned(
                      bottom: 8.5,
                      left: itemSpan * index,
                      width: itemSpan,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onTap(index);
                        },
                        child: Column(
                          key: ValueKey(widget.icons[index]),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              width: isSelected ? _CurvedNavBar.circleSize : 26,
                              height: isSelected
                                  ? _CurvedNavBar.circleSize
                                  : 26,
                              alignment: Alignment.center,
                              transform: Matrix4.translationValues(
                                0,
                                isSelected
                                    ? -(_CurvedNavBar.circleSize / 2 - 17)
                                    : 0,
                                0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? widget.barColor
                                    : Colors.transparent,
                              ),
                              child: AnimatedAppIcon(
                                asset: widget.icons[index],
                                size: isSelected ? 22 : 20,
                                scale: scale,
                                strokeWidth: strokeWidth,
                                color: widget.restingIconColor,
                                selected: isSelected,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  widget.onTap(index);
                                },
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isSelected ? 0 : 1,
                              child: Column(
                                children: [
                                  const SizedBox(height: 1),
                                  Text(
                                    widget.labels[index],
                                    style: TextStyle(
                                      fontFamily: 'vazir',
                                      fontSize: 11,
                                      color: widget.restingIconColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
