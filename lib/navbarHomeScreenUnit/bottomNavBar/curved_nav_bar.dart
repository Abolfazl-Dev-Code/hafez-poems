part of 'bottom_nav_bar.dart';

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
                                      fontFamily: AppTextStyles.fontFamily,
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
